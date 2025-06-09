FactoryBot.define do
  factory :organization do
    id { SecureRandom.uuid }
    sequence(:name) { |n| "Organization #{n}" }
    sequence(:document) { |n| "111111/111#{n}" }
  end
end
