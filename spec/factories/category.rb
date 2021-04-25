# frozen_string_literal: true

FactoryBot.define do
  factory :category do
    sequence(:title) { |n| "Category: #{n}" }

    trait :invalid do
      title { nil }
    end
  end
end
