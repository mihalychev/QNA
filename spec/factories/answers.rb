# frozen_string_literal: true

FactoryBot.define do
  factory :answer do
    sequence(:body) { |n| "Answer body #{n}" }
    question
    user

    trait :invalid do
      body { nil }
    end
  end
end
