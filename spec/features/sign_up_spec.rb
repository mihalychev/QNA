require 'rails_helper'

feature 'User can sign up' do
  scenario 'Guest tries to sign up' do
    visit new_user_registration_path

    fill_in 'Email', with: 'reg@test.com'
    fill_in 'Password', with: '123456'
    fill_in 'Password confirmation', with: '123456'
    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end
end