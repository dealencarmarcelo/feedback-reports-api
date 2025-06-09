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

    describe 'affected_devices validation' do
      context 'with negative value' do
        before { subject.affected_devices = -1 }

        it 'is not valid' do
          expect(subject).not_to be_valid
          expect(subject.errors[:affected_devices]).to include('must be greater than or equal to 0')
        end
      end

      context 'with zero value' do
        before { subject.affected_devices = 0 }

        it 'is valid' do
          expect(subject).to be_valid
        end
      end

      context 'with positive value' do
        before { subject.affected_devices = 10 }

        it 'is valid' do
          expect(subject).to be_valid
        end
      end
    end

    describe 'estimated_affected_accounts validation' do
      context 'with negative value' do
        before { subject.estimated_affected_accounts = -1 }

        it 'is not valid' do
          expect(subject).not_to be_valid
          expect(subject.errors[:estimated_affected_accounts]).to include('must be greater than or equal to 0')
        end
      end

      context 'with zero value' do
        before { subject.estimated_affected_accounts = 0 }

        it 'is valid' do
          expect(subject).to be_valid
        end
      end

      context 'with positive value' do
        before { subject.estimated_affected_accounts = 5 }

        it 'is valid' do
          expect(subject).to be_valid
        end
      end
    end

    describe 'processed_time validation' do
      context 'with nil value' do
        before { subject.processed_time = nil }

        it 'is not valid' do
          expect(subject).not_to be_valid
          expect(subject.errors[:processed_time]).to include("can't be blank")
        end
      end

      context 'with valid datetime' do
        before { subject.processed_time = Time.current }

        it 'is valid' do
          expect(subject).to be_valid
        end
      end
    end
  end

  describe 'database columns' do
    it { should have_db_column(:affected_devices).of_type(:integer) }
    it { should have_db_column(:estimated_affected_accounts).of_type(:integer) }
    it { should have_db_column(:processed_time).of_type(:datetime) }
    it { should have_db_column(:feedback_id).of_type(:integer) }
  end

  describe 'database indexes' do
    it { should have_db_index(:feedback_id) }
  end
end
