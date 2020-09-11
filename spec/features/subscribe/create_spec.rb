require 'rails_helper'

feature 'User can subscribe to a question' do
  given(:user) { create :user }
  given!(:question) { create :question }

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'tries to subscribe to a question', :js do
      click_on 'Subscribe'
      expect(page).to_not have_link 'Subscribe'
      expect(page).to have_link 'Unsubscribe'
    end
  end

  describe 'Unauthenticated user' do
    scenario 'tries to subscribe to a question' do
      visit question_path(question)
      expect(page).to_not have_link 'Subscribe'
    end
  end
end