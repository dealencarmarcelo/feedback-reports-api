FactoryBot.define do
  factory :feedback_result do
    association :feedback
    affected_devices { rand(1..100) }
    estimated_affected_accounts { rand(1..50) }
    processed_time { Time.current }
  end
end
