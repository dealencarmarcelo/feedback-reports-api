class FeedbackResult < ApplicationRecord
  establish_connection :clickhouse
  self.table_name = "feedback_results"
  self.primary_key = :id

  belongs_to :feedback, foreign_key: "feedback_id"

  validates :affected_devices, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :estimated_affected_accounts, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :processed_time, presence: true
end
