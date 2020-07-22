FactoryBot.define do
  sequence :body do |n|
    "body: #{n}"
  end

  factory :answer do
    body { "MyText" }

    trait :invalid do
      body { nil }
    end
  end

  factory :rand_body_answer, class: Answer do
    body
    question
  end
end
