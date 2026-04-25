require "open3"
require "tempfile"
require "timeout"

class CodeExecutionWorker
  include Sidekiq::Job
  sidekiq_options queue: "default", retry: 1

  MAX_OUTPUT = 10 * 1024 # 10KB

  def perform(submission_id)
    # Atomic idempotency fix
    # Single DB operation — read + update in one atomic query
    # Prevents race condition where two workers both read "pending"
    # and both proceed to execute
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
    tmp = Tempfile.new(["solution", ".py"])
    tmp.write(code)
    tmp.flush

    cmd = [
      "docker", "run", "--rm",
      "--network", "none",
      "--memory", "128m",
      "--memory-swap", "128m",
      "--cpus", "0.5",
      "--ulimit", "nproc=32:32",
      "-i",
      "-v", "#{tmp.path}:/solution.py:ro",
      "python:3.11-alpine",
      "python3", "/solution.py"
    ]

    stdout      = nil
    stderr      = nil
    proc_status = nil

    Timeout.timeout(10) do
      stdout, stderr, proc_status = Open3.capture3(*cmd, stdin_data: stdin_input)
    end

    stdout = stdout.to_s
    stderr = stderr.to_s

    if stdout.bytesize > MAX_OUTPUT
      stdout = stdout.byteslice(0, MAX_OUTPUT) + "\n[Output truncated]"
    end

    {
      output:    stdout.strip,
      stderr:    stderr.strip,
      error:     !proc_status.success?,
      timed_out: false
    }

  rescue Errno::ENOENT
    { output: "", stderr: "Docker is not available", error: true, timed_out: false }

  rescue Timeout::Error
    { output: "", stderr: "Time limit exceeded", error: true, timed_out: true }

  ensure
    tmp.close
    tmp.unlink
  end
end