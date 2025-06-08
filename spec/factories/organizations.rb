FactoryBot.define do
  factory :organization do
    id { SecureRandom.uuid }
    sequence(:name) { |n| "Organization #{n}" }
  end
end
