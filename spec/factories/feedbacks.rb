FactoryBot.define do
  factory :feedback do
    association :organization
    association :user
    account_id { SecureRandom.uuid }
    installation_id { SecureRandom.uuid }
    encoded_installation_id { Base64.encode64("#{installation_id}:some-app-id").strip }
    feedback_type { 'verified' }
    feedback_time { Time.current }

    after(:build) do |feedback|
      create(:organization_user, organization: feedback.organization, user: feedback.user) unless
        OrganizationUser.exists?(organization: feedback.organization, user: feedback.user)
    end

    trait :with_result do
      after(:create) do |feedback|
        create(:feedback_result, feedback: feedback)
      end
    end

    trait :reset do
      feedback_type { 'reset' }
    end

    trait :account_takeover do
      feedback_type { 'account_takeover' }
    end

    trait :identity_fraud do
      feedback_type { 'identity_fraud' }
    end

    trait :verified do
      feedback_type { 'verified' }
    end
  end
end
