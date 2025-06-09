require 'rails_helper'

RSpec.describe Feedback, type: :model do
  describe 'associations' do
    it { should belong_to(:organization) }
    it { should belong_to(:user).with_foreign_key('reported_by_user_id') }
    it { should have_one(:feedback_result).dependent(:destroy) }
  end

  describe 'validations' do
    let!(:organization) { create(:organization) }
    subject { build(:feedback, organization: organization) }

    it { should validate_presence_of(:organization_id) }
    it { should validate_presence_of(:account_id) }
    it { should validate_presence_of(:installation_id) }
    it { should validate_presence_of(:feedback_time) }

    it { should validate_inclusion_of(:feedback_type).in_array(%w[verified reset account_takeover identity_fraud]) }

    it 'validates UUID format for reported_by_user_id' do
      str_format_uuid = build(:feedback, reported_by_user_id: 'invalid-uuid')
      int_format_uuid = build(:feedback, reported_by_user_id: 10)

      expect(str_format_uuid).not_to be_valid
      expect(str_format_uuid.errors[:user]).to be_present

      expect(int_format_uuid).not_to be_valid
      expect(int_format_uuid.errors[:user]).to be_present
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
end
