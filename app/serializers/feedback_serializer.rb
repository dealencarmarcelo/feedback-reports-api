class FeedbackSerializer
  include JSONAPI::Serializer

  attributes :id, :organization_id, :reported_by_user_id, :account_id,
         :installation_id, :encoded_installation_id, :feedback_type,
         :feedback_time

  attribute :reported_by do |object|
    p User.find_by(id: object.reported_by_user_id)
    object&.user&.name || "N/A"
  end

  attribute :affected_devices do |object|
    object.feedback_result.affected_devices
  end

  attribute :estimated_affected_accounts do |object|
    object.feedback_result.estimated_affected_accounts
  end
end
