require "open3"
require "tempfile"
require "timeout"

class CodeExecutionWorker
  include Sidekiq::Job

  sidekiq_options queue: "default", retry: 1

  def perform(submission_id)
    submission = Submission.find(submission_id)

    return unless submission.status == "pending"

    submission.update!(status: "running")

    # Pass both code AND the problem's input to run_code
    result = run_code(submission.code, submission.problem.input.to_s)
    status = evaluate(result[:output], submission.problem.expected_output, result[:error])

    submission.update!(status: status, output: result[:output])

  rescue ActiveRecord::RecordNotFound
    logger.warn "CodeExecutionWorker: submission #{submission_id} not found, skipping"

  rescue => e
    submission&.update!(status: "runtime_error", output: e.message)
    raise
  end

  private

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

    stdout     = nil
    stderr     = nil
    proc_status = nil

    Timeout.timeout(10) do
      # capture3 captures stdout, stderr, and exit status separately
      # stdin_data passes the problem's input to the running container
      stdout, stderr, proc_status = Open3.capture3(*cmd, stdin_data: stdin_input)
    end

    had_error = !proc_status.success?

    {
      output: stdout.to_s.strip,
      stderr: stderr.to_s.strip,
      error:  had_error
    }

  rescue Errno::ENOENT
    { output: "", stderr: "Docker is not available", error: true }

  rescue Timeout::Error
    { output: "", stderr: "Time limit exceeded", error: true }

  ensure
    tmp.close
    tmp.unlink
  end

  def evaluate(actual_output, expected_output, had_error)
    return "runtime_error" if had_error

    actual   = actual_output.to_s.strip
    expected = expected_output.to_s.strip

    actual == expected ? "accepted" : "wrong_answer"
  end

end