class FeedbackResultSerializer < ActiveModel::Serializer
  attributes :affected_devices, :estimated_affected_accounts
end
