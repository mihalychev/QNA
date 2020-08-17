require 'rails_helper'

feature 'User can view his rewards' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'User views his rewards' do
    sign_in(user)
    rewards = create_list(:reward, 3, user: user, question: question)

    visit rewards_path

    rewards.each do |r|
      expect(page).to have_content r.question.title
      expect(page).to have_content r.title
      expect(page).to have_css 'img'
    end
  end
end