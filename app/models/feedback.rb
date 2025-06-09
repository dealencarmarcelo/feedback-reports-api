class Feedback < ApplicationRecord
  establish_connection :clickhouse
  self.table_name = "feedbacks"

  belongs_to :user, foreign_key: "reported_by_user_id"
  belongs_to :organization
  has_one :feedback_result, dependent: :destroy, primary_key: "id", foreign_key: "feedback_id"

  validates :organization_id, presence: true
  validates :account_id, presence: true, format: { with: /\A[0-9a-f-]{36}\z/i }
  validates :installation_id, presence: true, format: { with: /\A[0-9a-f-]{36}\z/i }
  validates :encoded_installation_id, presence: true
  validates :feedback_type, inclusion: { in: %w[verified reset account_takeover identity_fraud] }
  validates :feedback_time, presence: true

  scope :by_organization, ->(org_id) { where(organization_id: org_id) }
  scope :by_account_ids, ->(ids) { where(account_id: ids) }
  scope :by_encoded_installation_ids, ->(ids) { where(encoded_installation_id: ids) }
  scope :by_feedback_types, ->(types) { where(feedback_type: types) }
  scope :by_feedback_time_range, ->(start_time, end_time) { where(feedback_time: start_time..end_time) }

  def self.with_results_by_processed_time_range(start_time, end_time)
    joins(:feedback_result).where(feedback_results: { processed_time: start_time..end_time })
  end

  private

  def validate_encoded_installation_id
    return unless encoded_installation_id.present?

    begin
      decoded = Base64.decode64(encoded_installation_id)
      installation_part = decoded.split(":").first
      unless installation_part == installation_id
        errors.add(:encoded_installation_id, "does not match installation_id")
      end
    rescue => e
      errors.add(:encoded_installation_id, "invalid base64 encoding")
    end
  end
end
