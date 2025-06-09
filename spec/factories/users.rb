FactoryBot.define do
  factory :user do
    organization
    id { SecureRandom.uuid }
    name { Faker::Name.name }
    email { Faker::Internet.unique.email }
  end
end
