require 'rails_helper'

RSpec.describe Feedback, type: :model do
  describe 'associations' do
    it { should belong_to(:organization) }
    it { should belong_to(:user).with_foreign_key('reported_by_user_id') }
    it { should have_one(:feedback_result).dependent(:destroy) }
  end

  describe 'validations' do
    subject { build(:feedback) }

    it { should validate_presence_of(:organization_id) }
    it { should validate_presence_of(:account_id) }
    it { should validate_presence_of(:installation_id) }
    it { should validate_presence_of(:encoded_installation_id) }
    it { should validate_presence_of(:feedback_time) }

    it { should validate_inclusion_of(:feedback_type).in_array(%w[verified reset account_takeover identity_fraud]) }

    it 'validates UUID format for reported_by_user_id' do
      str_format_uuid = build(:feedback, reported_by_user_id: 'invalid-uuid')
      int_format_uuid = build(:feedback, reported_by_user_id: 10)

      expect(str_format_uuid).not_to be_valid
      expect(str_format_uuid.errors[:reported_by_user_id]).to be_present

      expect(int_format_uuid).not_to be_valid
      expect(int_format_uuid.errors[:reported_by_user_id]).to be_present
    end

    it 'validates UUID format for organization_id' do
      str_format_uuid = build(:feedback, organization_id: 'invalid-uuid')
      int_format_uuid = build(:feedback, organization_id: 10)

      expect(str_format_uuid).not_to be_valid
      expect(str_format_uuid.errors[:organization_id]).to be_present

      expect(int_format_uuid).not_to be_valid
      expect(int_format_uuid.errors[:organization_id]).to be_present
    end

    it 'validates UUID format for account_id' do
      str_format_uuid = build(:feedback, account_id: 'invalid-uuid')
      int_format_uuid = build(:feedback, account_id: 10)

      expect(str_format_uuid).not_to be_valid
      expect(str_format_uuid.errors[:account_id]).to be_present

      expect(int_format_uuid).not_to be_valid
      expect(int_format_uuid.errors[:account_id]).to be_present
    end

    it 'validates UUID format for installation_id' do
      str_format_uuid = build(:feedback, account_id: 'invalid-uuid')
      int_format_uuid = build(:feedback, account_id: 10)

      expect(str_format_uuid).not_to be_valid
      expect(str_format_uuid.errors[:account_id]).to be_present

      expect(int_format_uuid).not_to be_valid
      expect(int_format_uuid.errors[:account_id]).to be_present
    end
  end

  describe 'scopes' do
    let!(:organization) { create(:organization) }
    let(:another_organization) { create(:organization) }
    let!(:user) { create(:user, organization_id: organization.id) }
    let(:verified_feedback) { create(:feedback, :with_result, organization: organization, user: user, feedback_type: 'verified') }
    let(:reset_feedback) { create(:feedback, organization: organization, user: user, feedback_type: 'reset') }

    describe '.by_organization' do
      context "an organization with feedbacks" do
        it 'returns the feedbacks' do
          feedback = Feedback.by_organization(organization.id)
          [ verified_feedback, reset_feedback ].each do |f|
            expect(feedback).to include(f)
          end
        end
      end

      context "an organization without feedbacks" do
        it 'returns empty list' do
          feedback = Feedback.by_organization(another_organization.id)
          [ verified_feedback, reset_feedback ].each do |f|
            expect(feedback).not_to include(f)
          end
          expect(feedback).to be_empty
        end
      end
    end

    describe '.by_feedback_types' do
      it 'filters by single feedback type' do
        feedbacks = Feedback.by_feedback_types([ 'verified' ])
        expect(feedbacks).to include(verified_feedback)
        expect(feedbacks).not_to include(reset_feedback)
      end

      it 'filters by multiples feedback types' do
        feedbacks = Feedback.by_feedback_types([ 'verified', 'reset' ])
        expect(feedbacks).to include(verified_feedback)
        expect(feedbacks).not_to include(reset_feedback)
      end
    end
  end
end
