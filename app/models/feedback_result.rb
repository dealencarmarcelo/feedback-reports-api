class FeedbackResult < ApplicationRecord
  establish_connection :clickhouse
  self.table_name = "feedback_results"

  belongs_to :feedback

  validates :affected_devices, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :estimated_affected_accounts, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :processed_time, presence: true
end
