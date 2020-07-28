FactoryBot.define do
  factory :question do
    title { "MyString" }
    body { "MyText" }
    user
    
    trait :invalid do
      title { nil }
    end
    
    trait :rand do
      sequence(:title) { |n| "title: #{n}" }
    end
  end
end
