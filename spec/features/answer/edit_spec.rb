require 'rails_helper'

feature 'User can edit his answer' do
  given!(:user) { create(:user) }
  given(:user2) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }

  describe 'Authenticated user', js: true do
    context 'author' do
      background do
        sign_in(user)
        visit question_path(question)
      end
  
      scenario 'edits his answer' do
        click_on 'Edit'
  
        within "#answer-#{answer.id}" do
          fill_in 'Body', with: 'edited answer'
          click_on 'Save'
  
          expect(page).to_not have_content answer.body
          expect(page).to have_content 'edited answer'
          expect(page).to_not have_selector 'textarea'
        end
      end
  
      scenario 'edits his answer with errors' do
        click_on 'Edit'
  
        within "#answer-#{answer.id}" do
          fill_in 'Body', with: nil
          click_on 'Save'
        end
        
        expect(page).to have_content "Body can't be blank"
      end
    end

    scenario "tries to edit other user's answer" do
      sign_in(user2)
      visit question_path(question)
      expect(page).to_not have_link 'Edit'
    end
  end

  scenario 'Unauthenticated user tries to edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end
end