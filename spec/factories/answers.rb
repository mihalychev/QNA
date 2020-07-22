FactoryBot.define do
  sequence :body do |n|
    "body: #{n}"
  end

  factory :answer do
    body { "Answer body" }
    question
    user

    trait :invalid do
      body { nil }
    end
  end

  factory :rand_body_answer, class: Answer do
    body
    question
    user
  end
end
