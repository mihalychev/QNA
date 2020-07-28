FactoryBot.define do
  factory :answer do
    body { "Answer body" }
    question
    user

    trait :invalid do
      body { nil }
    end

    trait :rand do
      sequence(:body) { |n| "body: #{n}" }
    end
  end
end
