class Api::V1::FeedbacksController < ApplicationController
  before_action :validate_organization_id

  def index
    service = Feedbacks::ListService.new(
      organization_id: current_organization.id,
      page_size: params[:page_size],
      cursor: params[:cursor],
      filters: filter_params
    )

    result = service.call

    if result
      render json: result[:feedbacks],
             adapter: :json,
             each_serializer: FeedbackSerializer,
             meta: result[:meta]
    else
      render json: { errors: service.errors }, status: :unprocessable_entity
    end
  end

  def stats
    stats = @organization.monthly_stats

    render json: {
      organization_id: @organization.id,
      stats: stats,
      period: "30_days"
    }
  end

  private

  def filter_params
    params.permit(
      :start_date,
      :end_date,
      :date_type,
      account_ids: [],
      installation_ids: [],
      feedback_types: [],
      encoded_installation_ids: [],
    ).to_h
  end
end
