class Api::V1::FeedbacksController < ApplicationController
  def index
    result = Feedbacks::List.call(params: permitted_params)
    render json: FeedbackSerializer.render(result[:feedbacks]), meta: result[:meta], status: :ok
  end

  private

  def permitted_params
    params.permit(
      :organization_id,
      :cursor,
      :start_date,
      :end_date,
      account_ids: [],
      encoded_installation_ids: [],
      feedback_types: [],
    )
  end
end
