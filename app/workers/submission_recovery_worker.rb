class SubmissionRecoveryWorker
  include Sidekiq::Job

  sidekiq_options queue: "default", retry: 0

  def perform
    recover_pending
    recover_running
  end

  private

  def recover_pending
    stuck = Submission.where(status: "pending")
                      .where("created_at < ?", 5.minutes.ago)

    stuck.each do |submission|
      logger.info "Recovery: re-enqueuing stuck pending submission #{submission.id}"
      CodeExecutionWorker.perform_async(submission.id)
    end
  end

  def recover_running
    stuck = Submission.where(status: "running")
                      .where("updated_at < ?", 5.minutes.ago)

    count = stuck.update_all(
      status: "runtime_error",
      output: "Execution timed out — worker may have crashed"
    )

    logger.info "Recovery: marked #{count} stuck running submissions as runtime_error" if count > 0
  end
end