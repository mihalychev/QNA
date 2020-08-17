FactoryBot.define do
  factory :reward do
    title { "MyString" }
    image { Rack::Test::UploadedFile.new("#{Rails.root}/spec/features/question/files/reward.jpg", 'image/jpg') }
  end
end
