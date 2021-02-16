require 'rails_helper'

feature 'User can delete answer' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, user: user, question: question) }

  describe 'Authenticated user', js: true do
    given(:user2) { create(:user) }

    scenario 'tries to delete his own answer' do
      sign_in(user)
      visit question_path(question)
      within "#answer-#{answer.id}" do
        click_on 'Delete'     
      end
      expect(page).to_not have_content answer.body
    end
  
    scenario 'tries to delete answer which belongs to another user' do
      sign_in(user2)
      visit question_path(question)
      expect(page).to_not have_content 'Delete'
    end
  end

  describe 'Unauthenticated user' do
    scenario 'tries to delete answer' do
      visit question_path(question)
      expect(page).to_not have_content 'Delete'
    end
  end
end