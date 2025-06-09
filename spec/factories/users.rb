FactoryBot.define do
  factory :user do
    association :organization
    id { SecureRandom.uuid }
    name { Faker::Name.name }
    email { Faker::Internet.unique.email }
  end
end
