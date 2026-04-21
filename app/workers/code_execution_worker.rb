class CodeExecutionWorker
  include Sidekiq::Job

  # retry: 1 — one retry covers transient failures like Docker hiccup
  # Most execution failures are deterministic (bad code won't pass on retry 15)
  # Default is 25 retries which wastes worker capacity on unrecoverable jobs
  sidekiq_options queue: "default", retry: 1

  def perform(submission_id)
    submission = Submission.find(submission_id)

    # Idempotency guard — if this job somehow runs twice,
    # skip it if already processed.
    # Without this, a retried job re-executes already evaluated code.
    return unless submission.status == "pending"

    submission.update!(status: "running")

    # Placeholder — simulates work being done
    # Phase 3 replaces this sleep with real Docker execution
    sleep 2

    submission.update!(
      status: "accepted",
      output: "placeholder — Docker execution coming in next commit"
    )

  rescue ActiveRecord::RecordNotFound
    # Submission deleted between enqueue and execution — safe to ignore
    logger.warn "CodeExecutionWorker: submission #{submission_id} not found, skipping"

  rescue => e
    # Catch everything else
    # Always write a terminal status so submission never stays
    # stuck in "running" permanently.
    # If stuck in "running", the frontend polls forever — bad UX
    submission&.update!(status: "runtime_error", output: e.message)
    raise
  end
end