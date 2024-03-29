# frozen_string_literal: true

FactoryBot.define do
  factory :question do
    sequence(:title) { |n| "Question title: #{n}" }
    sequence(:body) { |n| "Question body: #{n}" }
    category
    user

    trait :invalid do
      title { nil }
    end
  end
end
