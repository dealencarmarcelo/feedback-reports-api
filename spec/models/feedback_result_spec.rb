require 'rails_helper'

RSpec.describe FeedbackResult, type: :model do
  describe 'associations' do
    it { should belong_to(:feedback) }
  end

  describe 'validations' do
    subject { build(:feedback_result) }

    it { should validate_presence_of(:affected_devices) }
    it { should validate_presence_of(:estimated_affected_accounts) }
    it { should validate_presence_of(:processed_time) }

    it { should validate_numericality_of(:affected_devices).is_greater_than_or_equal_to(0) }
    it { should validate_numericality_of(:estimated_affected_accounts).is_greater_than_or_equal_to(0) }
  end
end
