require 'rails_helper'

feature 'User can sign out' do
  given(:user) { create(:user) }

  scenario 'User tris to log out' do
    sign_in(user)
    click_on 'Logout'
    expect(page).to have_content 'Signed out successfully.'
  end
end