require 'rails_helper'

feature 'User can add links to question' do
  given(:user) { create(:user) }
  given(:url) { 'https://www.google.com' }

  scenario 'User adds link when asks question' do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Title'
    fill_in 'Body', with: 'Body'
    fill_in 'Name', with: 'Google'
    fill_in 'Url', with: url

    click_on 'Ask'

    expect(page).to have_link 'Google', href: url
  end
end