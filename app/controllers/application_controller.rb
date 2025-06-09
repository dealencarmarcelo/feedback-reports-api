class ApplicationController < ActionController::API
  before_action :set_current_organization

  attr_reader :current_organization

  private

  def validate_organization_id
  end

  def set_current_organization
    unless params[:organization_id].present?
      render json: { error: "organization_id is required" }, status: :bad_request
    end

    @current_organization ||= Organization.find_by(id: params[:organization_id])
    render_error("Organization not found", :not_found) unless @current_organization
  end

  def render_error(message, status = :unprocessable_entity)
    render json: { error: message }, status: status
  end
end
