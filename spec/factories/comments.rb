# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    sequence(:body) { |n| "Comment body #{n}" }
    user

    trait :for_question do
      commentable { create :question }
    end

    trait :for_answer do
      commentable { create :answer }
    end

    trait :invalid do
      body { nil }
    end
  end
end
