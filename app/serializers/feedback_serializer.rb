class FeedbackSerializer < Blueprinter::Base
  identifier :id do |feedback_result, options|
    if feedback_result.id.is_a?(Array) # Se for um array, pegue o primeiro elemento
      feedback_result.id.second.to_s
    else # Caso contrário, apenas chame to_s (para o caso de já ser um UUID string)
      feedback_result.id.to_s
    end
  end

  fields :organization_id, :reported_by_user_id, :account_id,
         :installation_id, :encoded_installation_id, :feedback_type,
         :feedback_time

  association :feedback_result, blueprint: FeedbackResultSerializer, view: :default
end
