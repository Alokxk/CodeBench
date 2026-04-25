class Submission < ApplicationRecord
  belongs_to :problem

  STATUSES = %w[
    pending
    running
    accepted
    wrong_answer
    runtime_error
    time_limit_exceeded
  ].freeze

  validates :code,     presence: true
  validates :language, inclusion: { in: %w[python3] }
  validates :status,   inclusion: { in: STATUSES }
end