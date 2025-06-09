class Feedbacks::List
  include ActiveModel::Validations

  DEFAULT_PAGE_SIZE = 100
  MAX_PAGE_SIZE = 500

  validates :organization_id, presence: true
  validates :page_size, numericality: {
    greater_than: 0,
    less_than_or_equal_to: MAX_PAGE_SIZE
  }

  def self.call(params:)
    service = new(params)
    return service.failure_result if service.invalid?

    service.call
  end

  def initialize(params)
    @params = params.to_h.with_indifferent_access
    @organization_id = @params[:organization_id]
    @page_size = (@params[:page_size] || DEFAULT_PAGE_SIZE).to_i
    @filters = extract_filters
    @cursor = @params[:cursor]
  end

  def call
    feedbacks = query_builder.execute

    success_result(
      feedbacks: feedbacks,
      meta: build_meta(feedbacks)
    )
  rescue StandardError => e
    failure_result(error: e.message)
  end

  def failure_result(error: nil)
    {
      success: false,
      error: error || errors.full_messages.join(", "),
      feedbacks: [],
      meta: {}
    }
  end

  private

  def extract_filters
    @params.slice(
      :account_ids,
      :encoded_installation_ids,
      :feedback_types,
      :start_date,
      :end_date
    ).compact
  end

  def query_builder
    @query_builder ||= Feedbacks::QueryBuilder.new(
      organization_id: @organization_id,
      filters: @filters,
      cursor: @cursor,
      page_size: @page_size
    )
  end

  def build_meta(feedbacks)
    {
      next_cursor: feedbacks.last ? cursor_encoder.encode(feedbacks.last) : nil,
      page_size: @page_size,
      has_more: feedbacks.size == @page_size
    }
  end

  def cursor_encoder
    @cursor_encoder ||= Feedbacks::CursorEncoder.new
  end

  def success_result(data)
    { success: true }.merge(data)
  end
end
