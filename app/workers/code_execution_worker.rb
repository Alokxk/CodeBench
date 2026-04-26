require "open3"
require "securerandom"

class CodeExecutionWorker
  include Sidekiq::Job

  sidekiq_options queue: "default", retry: 1

  MAX_OUTPUT   = 10 * 1024
  TIME_LIMIT_S = 10

  def perform(submission_id)
    updated = Submission.where(id: submission_id, status: "pending")
                        .update_all(status: "running")
    return if updated == 0

    submission = Submission.find(submission_id)
    problem    = submission.problem
    test_cases = problem.test_cases.presence || [{
      "input"           => problem.input.to_s,
      "expected_output" => problem.expected_output.to_s
    }]

    start_time        = Time.now
    results           = test_cases.map { |tc| run_code(submission.code, tc["input"].to_s) }
    execution_time_ms = ((Time.now - start_time) * 1000).to_i

    passed = results.each_with_index.count do |result, i|
      !result[:error] &&
        result[:output].strip == test_cases[i]["expected_output"].to_s.strip
    end

    final_status = determine_status(results, passed, test_cases.size)

    submission.update!(
      status:            final_status,
      output:            results.first[:output],
      test_cases_passed: passed,
      test_cases_total:  test_cases.size,
      execution_time_ms: execution_time_ms
    )

  rescue ActiveRecord::RecordNotFound
    logger.warn "CodeExecutionWorker: submission #{submission_id} not found, skipping"
  rescue => e
    Submission.where(id: submission_id).update_all(
      status: "runtime_error",
      output: e.message
    )
    raise
  end

  private

  def determine_status(results, passed, total)
    return "time_limit_exceeded" if results.any? { |r| r[:timed_out] }
    return "runtime_error"       if results.any? { |r| r[:error] }
    return "accepted"            if passed == total
    "wrong_answer"
  end

  def run_code(code, stdin_input)
    dir            = Dir.mktmpdir("codebench_")
    container_name = "codebench_#{SecureRandom.hex(8)}"

    File.write(File.join(dir, "solution.py"), code)
    File.write(File.join(dir, "input.txt"),   stdin_input)

    cmd = [
      "docker", "run", "--rm",
      "--name",        container_name,
      "--network",     "none",
      "--memory",      "128m",
      "--memory-swap", "128m",
      "--cpus",        "0.5",
      "--ulimit",      "nproc=32:32",
      "-v", "#{dir}:/sandbox:ro",
      "python:3.11-alpine",
      "sh", "-c", "python3 /sandbox/solution.py < /sandbox/input.txt"
    ]

    timed_out = false
    killer = Thread.new do
      sleep TIME_LIMIT_S
      timed_out = true
      system("docker kill #{container_name} > /dev/null 2>&1")
    end

    stdout, stderr, proc_status = Open3.capture3(*cmd)

    # Process finished before timeout — stop the killer
    killer.kill
    killer.join

    stdout = stdout.to_s
    stderr = stderr.to_s

    if stdout.bytesize > MAX_OUTPUT
      stdout = stdout.byteslice(0, MAX_OUTPUT) + "\n[Output truncated]"
    end

    {
      output:    stdout.strip,
      stderr:    stderr.strip,
      error:     !timed_out && !proc_status.success?,
      timed_out: timed_out
    }

  rescue Errno::ENOENT
    { output: "", stderr: "Docker is not available", error: true, timed_out: false }

  ensure
    killer.kill rescue nil
    FileUtils.remove_entry(dir) if dir && Dir.exist?(dir)
    system("docker kill #{container_name} > /dev/null 2>&1") rescue nil
  end
end