# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    sequence(:body) { |n| "Comment body #{n}" }
    user

    trait :invalid do
      body { nil }
    end
  end
end
