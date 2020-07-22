FactoryBot.define do
  sequence :title do |n|
    "title: #{n}"
  end

  factory :question do
    title { "MyString" }
    body { "MyText" }
    user

    trait :invalid do
      title { nil }
    end
  end

  factory :rand_title_question, class: Question do
    title
    body { "MyTesx" }
    user
  end
end
