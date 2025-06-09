class ApplicationController < ActionController::API
  before_action :validate_organization_id

  attr_reader :current_organization

  private

  def validate_organization_id
    unless params[:organization_id].present?
      render json: { error: "organization_id is required" }, status: :bad_request
    end
  end

  def organization
    @current_organization ||= Organization.find_by(id: params[:organization_id])
  end

  def render_error(message, status = :unprocessable_entity)
    render json: { error: message }, status: status
  end
end
