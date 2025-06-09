FactoryBot.define do
  factory :organization do
    id { SecureRandom.uuid }
    sequence(:name) { |n| "Organization #{n}" }
    sequence(:document) { |n| "#{n}11111/111#{rand(1..1000)}" }
  end
end
