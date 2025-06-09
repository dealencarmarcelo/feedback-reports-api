class FeedbackSerializer < ActiveModel::Serializer
  attributes :id, :organization_id, :reported_by_user_id, :account_id,
         :installation_id, :encoded_installation_id, :feedback_type,
         :feedback_time, :feedback_type_label

  belongs_to :user
  has_one :feedback_result

  def feedback_type_label
    object.feedback_type.titleize
  end
end
