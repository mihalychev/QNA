# frozen_string_literal: true

FactoryBot.define do
  factory :link do
    name { 'URL' }
    url { 'https://test.test' }
  end
end
