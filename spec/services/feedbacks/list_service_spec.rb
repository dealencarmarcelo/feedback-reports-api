require 'rails_helper'

RSpec.describe Feedbacks::ListService do
  let(:organization_id) { create(:organization).id }
  let(:user) { create(:user) }
  let(:valid_feedback_attrs) do
    {
      organization_id: organization_id,
      reported_by_user_id: user.id,
      account_id: SecureRandom.uuid,
      installation_id: SecureRandom.uuid,
      encoded_installation_id: "encoded123",
      feedback_type: "verified",
      feedback_time: "2023-08-10 12:00:00"
    }
  end

  describe "#call" do
    context "when organization_id is missing" do
      it "returns nil and error" do
        service = described_class.new(organization_id: nil)
        result = service.call

        expect(result).to be_nil
        expect(service.errors[:organization_id]).to include("must be present")
      end
    end

    context "when feedback_type is invalid" do
      it "adds error to feedback_types" do
        service = described_class.new(
          organization_id: organization_id,
          filters: { feedback_types: [ "invalid_type" ] }
        )
        result = service.call

        expect(result).to be_nil
        expect(service.errors[:feedback_types]).to include("contains invalid feedback type")
      end
    end

    context "when date range is partially present" do
      it "adds error to date_range" do
        service = described_class.new(
          organization_id: organization_id,
          filters: { start_date: "2023-01-01" }
        )
        result = service.call

        expect(result).to be_nil
        expect(service.errors[:date_range]).to include("both start_date and end_date must be present")
      end
    end

    context "when date format is invalid" do
      it "adds error to date_range" do
        service = described_class.new(
          organization_id: organization_id,
          filters: { start_date: "abc", end_date: "xyz" }
        )
        result = service.call

        expect(result).to be_nil
        expect(service.errors[:date_range]).to include("invalid date format")
      end
    end

    context "when date_type is invalid" do
      it "adds error to date_type" do
        service = described_class.new(
          organization_id: organization_id,
          filters: {
            start_date: "2023-01-01",
            end_date: "2023-01-31",
            date_type: "some_invalid_type"
          }
        )
        result = service.call

        expect(result).to be_nil
        expect(service.errors[:date_type]).to include("must be feedback_time or processed_time")
      end
    end

    context "when filters are valid" do
      before do
        create(:feedback, **valid_feedback_attrs)
      end

      it "returns feedbacks matching filters" do
        service = described_class.new(
          organization_id: organization_id,
          filters: { feedback_types: [ "verified" ] }
        )

        result = service.call

        expect(result[:feedbacks].count).to eq(1)
        expect(result[:feedbacks].first.feedback_type).to eq("verified")
        expect(result[:meta][:total]).to eq(1)
      end
    end

    context "with pagination" do
      before do
        3.times do |i|
          create(:feedback, **valid_feedback_attrs.merge(feedback_time: "2023-08-10 12:0#{i}:00"))
        end
      end

      it "respects page size and returns cursor" do
        service = described_class.new(
          organization_id: organization_id,
          page_size: 2
        )

        result = service.call

        expect(result[:feedbacks].size).to eq(2)
        expect(result[:meta][:page_size]).to eq(2)
        expect(result[:meta][:cursor]).not_to be_nil
        expect(result[:meta][:has_more]).to eq(true).or eq(false)
      end
    end
  end
end
