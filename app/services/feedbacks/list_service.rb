module Feedbacks
  class ListService
    attr_reader :organization_id, :filters, :page_size, :cursor
    attr_accessor :errors

    DEFAULT_PAGE_SIZE = 500

    def initialize(organization_id:, filters: {}, page_size: nil, cursor: nil)
      @organization_id = organization_id
      @filters = filters || {}
      @page_size = page_size || DEFAULT_PAGE_SIZE
      @cursor = cursor
      @errors = {}
    end

    def call
      return nil unless valid?
      feedbacks = fetch_feedbacks
      {
        feedbacks: feedbacks,
        meta: build_meta(feedbacks)
      }
    end

    private

    def valid?
      validate_organization_id
      validate_filters if filters.present?
      errors.empty?
    end

    def validate_organization_id
      return if organization_id.present?

      errors[:organization_id] = [ "must be present" ]
      false
    end

    def validate_filters
      if filters[:feedback_types].present?
        unless (filters[:feedback_types] - valid_feedback_types).empty?
          errors[:feedback_types] = [ "contains invalid feedback type" ]
        end
      end

      if filters[:start_date].present? ^ filters[:end_date].present?
        errors[:date_range] = [ "both start_date and end_date must be present" ]
      end

      validate_dates if filters[:start_date].present? && filters[:end_date].present?
    end

    def validate_dates
      begin
        Date.parse(filters[:start_date])
        Date.parse(filters[:end_date])
      rescue Date::Error
        errors[:date_range] = [ "invalid date format" ]
      end

      if filters[:date_type].present? && ![ "feedback_time", "processed_time" ].include?(filters[:date_type])
        errors[:date_type] = [ "must be feedback_time or processed_time" ]
      end
    end

    def fetch_feedbacks
      query = base_query
      query = apply_filters(query)
      apply_pagination(query)
    end

    def base_query
      Feedback
        .includes(:feedback_result, :user)
        .where(organization_id: organization_id)
      # .select('feedbacks.*, feedback_results.*, users.name as reporter_name')
    end

    def apply_filters(query)
      query = apply_id_filters(query)
      query = apply_feedback_type_filter(query)
      query = apply_date_filter(query)
      query
    end

    def apply_id_filters(query)
      if filters[:account_ids].present?
        query = query.where(account_id: filters[:account_ids])
      end

      if filters[:installation_ids].present?
        query = query.where(encoded_installation_id: filters[:installation_ids])
      end

      query
    end

    def apply_feedback_type_filter(query)
      return query unless filters[:feedback_types].present?

      query.where(feedback_type: filters[:feedback_types])
    end

    def apply_date_filter(query)
      return query unless filters[:start_date].present? && filters[:end_date].present?

      date_column = filters[:date_type] == "processed_time" ?
        "feedback_results.processed_time" :
        "feedbacks.feedback_time"

      query.where("#{date_column} BETWEEN ? AND ?",
        Time.zone.parse(filters[:start_date]).beginning_of_day,
        Time.zone.parse(filters[:end_date]).end_of_day)
    end

    def apply_pagination(query)
      if cursor.present?
        query = query.where("feedbacks.feedback_time < ?", cursor)
      end

      query.order("feedbacks.feedback_time DESC").limit(page_size)
    end

    def build_meta(feedbacks)
      {
        page_size: page_size,
        cursor: feedbacks.last.feedback_time
        # has_more: has_more?,
        # total: total_count
      }
    end

    def has_more?
      return false unless @feedbacks

      total_count > (cursor.to_i + page_size)
    end

    def total_count
      @total_count ||= base_query.count
    end

    def valid_feedback_types
      [ "verified", "reset", "account_takeover", "identity_fraud" ]
    end
  end
end
