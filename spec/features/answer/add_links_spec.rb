require 'rails_helper'

feature 'User can add links to answer' do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:url) { 'https://www.google.com' }

  scenario 'User adds link when asks answer', js: true do
    sign_in(user)
    visit question_path(question)
    
    within '.answers' do
      fill_in 'Body', with: 'Body'
      fill_in 'Link', with: 'Google'
      fill_in 'Url', with: url

      click_on 'Answer'

      expect(page).to have_link 'Google', href: url
    end
  end
end