require 'rails_helper'

RSpec.describe "Api::V1::Feedbacks", type: :request do
  let(:organization) { create(:organization) }
  let(:user) { create(:user, :with_organization) }
  let(:feedback) { create(:feedback, :with_result, organization: organization, user: user) }
  let(:valid_params) do
    {
      organization_id: organization.id,
      page_size: 10,
      date_type: 'feedback_time'
    }
  end

  describe "GET /index" do
    context "when valid parameters" do
      before do
        organization = create(:organization)
        create_list(:feedback, 2, organization: organization)
        get '/api/v1/feedbacks', params: valid_params
      end

      it "returns a successful response" do
        expect(response).to be_successful
      end

      it "returns feedbacks in the response" do
        json_response = JSON.parse(response.body)
        feedbacks = json_response['data']
        expect(feedbacks.size).to eq(2)
        feedbacks.each do |feedback|
          expect(feedback).to include('id', 'organization_id', 'reported_by_user_id', 'account_id',
                                     'installation_id', 'encoded_installation_id', 'feedback_type',
                                     'feedback_time', 'feedback_result')
        end
      end

      it "includes pagination meta data" do
        json_response = JSON.parse(response.body)
        expect(json_response['meta']).to include('page_size', 'has_more', 'total')
      end
    end

    context "when invalid parameters" do
      let(:invalid_params) { { organization_id: nil } }

      before do
        get '/api/v1/feedbacks', params: invalid_params
      end

      it "returns unprocessable entity status" do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "returns error message" do
        json_response = JSON.parse(response.body)
        expect(json_response['error']).to eq('Invalid parameters')
      end
    end

    context "when filtering by feedback types" do
      let(:feedback_types) { [ 'verified', 'reset' ] }

      before do
        organization = create(:organization)
        create(:feedback, organization: organization, feedback_type: 'verified')
        create(:feedback, organization: organization, feedback_type: 'reset')
        create(:feedback, organization: organization, feedback_type: 'account_takeover')

        get '/api/v1/feedbacks', params: valid_params.merge(feedback_types: feedback_types)
      end

      it "returns only filtered feedback types" do
        json_response = JSON.parse(response.body)
        feedbacks = json_response['data']
        expect(feedbacks.size).to eq(2)
        feedbacks.each do |feedback|
          expect(feedback_types).to include(feedback['feedback_type'])
        end
      end
    end

    context "when filtering by date range" do
      let(:start_date) { Date.today - 1.day }
      let(:end_date) { Date.today }

      before do
        organization = create(:organization)
        Timecop.freeze(start_date) do
          create(:feedback, organization: organization, feedback_time: start_date)
        end

        Timecop.freeze(end_date) do
          create(:feedback, organization: organization, feedback_time: end_date)
          create(:feedback, organization: organization, feedback_time: end_date + 1.day)
        end

        get '/api/v1/feedbacks', params: valid_params.merge(
          start_date: start_date.to_s,
          end_date: end_date.to_s
        )
      end

      after do
        Timecop.return
      end

      it "returns feedbacks within date range" do
        json_response = JSON.parse(response.body)
        feedbacks = json_response['data']
        expect(feedbacks.size).to eq(2)
        feedbacks.each do |feedback|
          date = Date.parse(feedback['feedback_time'])
          expect(date).to be_between(start_date, end_date)
        end
      end
    end

    context "when using cursor pagination" do
      let(:page_size) { 2 }

      before do
        organization = create(:organization)
        create_list(:feedback, 5, organization: organization)
        get '/api/v1/feedbacks', params: valid_params.merge(page_size: page_size)
      end

      it "returns correct number of feedbacks" do
        json_response = JSON.parse(response.body)
        feedbacks = json_response['data']
        expect(feedbacks.size).to eq(page_size)
      end

      it "includes next_cursor in meta" do
        json_response = JSON.parse(response.body)
        expect(json_response['meta']['next_cursor']).not_to be_nil
      end
    end
  end
end
