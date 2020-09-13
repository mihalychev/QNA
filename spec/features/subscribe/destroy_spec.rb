require 'rails_helper'

feature 'User can unsubscribe from a question' do
  given(:user) { create :user }
  given(:question) { create :question }

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit question_path(question)
      click_on 'Subscribe'
    end

    scenario 'tries to unsubscribe from a question', :js do
      click_on 'Unsubscribe'
      expect(page).to_not have_link 'Unsubscribe'
      expect(page).to have_link 'Subscribe'
    end
  end

  describe 'Unauthenticated user' do
    scenario 'tries to unsubscribe from a question' do
      visit question_path(question)
      expect(page).to_not have_link 'Unsubscribe'
    end
  end
end