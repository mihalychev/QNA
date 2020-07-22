require 'rails_helper'

feature 'User can sign up' do
  given(:user) { create(:user) }

  scenario 'Guest tries to sign up' do
    visit new_user_registration_path

    fill_in 'Email', with: 'reg@test.com'
    fill_in 'Password', with: '123456'
    fill_in 'Password confirmation', with: '123456'
    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'Registered user try to sign up' do
    visit new_user_registration_path

    fill_in 'Email', with: user.email
    fill_in 'Password', with: '123456'
    fill_in 'Password confirmation', with: '123456'
    click_on 'Sign up'

    expect(page).to have_content 'Email has already been taken'
  end

  scenario 'Guest tries to sign up with errors' do
    visit new_user_registration_path
    click_on 'Sign up'
    expect(page).to have_content "Email can't be blank"
  end
end