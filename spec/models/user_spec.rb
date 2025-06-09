require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should belong_to(:organization) }
    it { should have_many(:feedbacks).with_foreign_key('reported_by_user_id') }
  end

  describe 'validations' do
    let(:organization) { create(:organization) }

    subject { build(:user, organization_id: organization.id) }

    describe 'name validation' do
      it { should validate_presence_of(:name) }

      context 'with valid name' do
        before { subject.name = 'John Doe' }

        it 'is valid' do
          expect(subject).to be_valid
        end
      end

      context 'with empty name' do
        before { subject.name = '' }

        it 'is not valid' do
          expect(subject).not_to be_valid
          expect(subject.errors[:name]).to include("can't be blank")
        end
      end
    end

    describe 'email validation' do
      it { should validate_presence_of(:email) }

      context 'with valid email' do
        before { subject.email = 'user@example.com' }

        it 'is valid' do
          expect(subject).to be_valid
        end
      end

      context 'with invalid email' do
        before { subject.email = 'invalid-email' }

        it 'is not valid' do
          expect(subject).not_to be_valid
          expect(subject.errors[:email]).to include('is invalid')
        end
      end
    end
  end

  describe 'database columns' do
    it { should have_db_column(:name).of_type(:string) }
    it { should have_db_column(:email).of_type(:string) }
    it { should have_db_column(:organization_id).of_type(:uuid) }
  end

  describe 'database indexes' do
    it { should have_db_index(:email).unique(true) }
    it { should have_db_index(:organization_id) }
  end
end
