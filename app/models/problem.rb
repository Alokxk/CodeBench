class Problem < ApplicationRecord
  has_many :submissions, dependent: :destroy

  validates :title,           presence: true
  validates :description,     presence: true
  validates :difficulty,      inclusion: { in: %w[Easy Medium Hard] }
  validates :expected_output, presence: true
end