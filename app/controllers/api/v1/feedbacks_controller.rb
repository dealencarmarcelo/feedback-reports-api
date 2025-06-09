class Api::V1::FeedbacksController < ApplicationController
  before_action :validate_organization_id
  before_action :load_organization

  def index
    service = Feedbacks::ListService.new(
      organization_id: @organization.id,
      page_size: params[:page_size],
      cursor: params[:cursor].to_time,
      filters: filter_params
    )

    result = service.call

    if result
      render json: { data: FeedbackSerializer.new(result[:feedbacks]).serializable_hash[:data], meta: result[:meta] }
      # render json: {
      #   data: FeedbackSerializer.new(result[:feedbacks]),
      #   meta: result[:meta].merge(
      #     organization: {
      #       id: @organization.id,
      #       name: @organization.name
      #       # plan: @organization.plan
      #     }
      #   )
      # }
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
      account_ids: [],
      installation_ids: [],
      feedback_types: [],
      start_date: :string,
      end_date: :string,
      date_type: :string # can be 'feedback_time' or 'processed_time'
    ).to_h
  end

  def validate_organization_id
    head :bad_request unless params[:organization_id].present?
  end

  def load_organization
    @organization = Organization.find(params[:organization_id])
  rescue ActiveRecord::RecordNotFound
    head :not_found
  end

  def serialize_feedbacks(feedbacks)
    feedbacks.map do |feedback|
      {
        id: feedback.id,
        account_id: feedback.account_id,
        installation_id: feedback.installation_id,
        encoded_installation_id: feedback.encoded_installation_id,
        feedback_type: feedback.feedback_type,
        feedback_time: feedback.feedback_time,
        processed_time: feedback.processed_time,
        affected_devices: feedback.affected_devices,
        estimated_affected_accounts: feedback.estimated_affected_accounts,
        reported_by: feedback.reporter_name
      }
    end
  end
end
