require 'rails_helper'

feature 'User can delete question' do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:user2) { create(:user) }

  describe 'Authenticated user' do
    scenario 'tries to delete his own question' do
      sign_in(user)
      visit question_path(question)
      click_on 'Delete question'
      expect(page).to_not have_content question.title
    end
  
    scenario 'tries to delete question which belongs to another user' do
      sign_in(user2)
      visit question_path(question)
      expect(page).to_not have_content 'Delete question'
    end
  end

  describe 'Unauthenticated user' do
    scenario 'tries to delete question' do
      visit question_path(question)
      expect(page).to_not have_content 'Delete question'
    end
  end

end