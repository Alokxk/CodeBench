class Problem < ApplicationRecord
  has_many :submissions, dependent: :destroy

  validates :title,           presence: true
  validates :description,     presence: true
  validates :expected_output, presence: true
end