require 'rails_helper'

RSpec.describe Organization, type: :model do
  describe 'associations' do
    it { should have_many(:feedbacks).dependent(:destroy) }
    it { should have_many(:feedback_results).through(:feedbacks) }
    it { should have_many(:users).dependent(:destroy) }
  end

  describe 'validations' do
    subject { build(:organization) }

    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_least(2).is_at_most(50) }
  end
end
