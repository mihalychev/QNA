require 'rails_helper'

feature 'User can mark the answer as best' do
  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question) }
  given!(:answer2) { create(:answer, question: question) }

  describe 'Authenticated user', js: true do
    describe 'author' do
      background do
        sign_in(user)
        visit question_path(question)
      end

      scenario 'tries to mark the answer as best' do
        within '.answer:first-child' do
          click_on 'Mark as best'
          expect(page).to have_content 'BEST'      
        end
      end
  
      scenario 'tries to mark another answer as best' do
        within "#answer-#{answer.id}" do
          click_on 'Mark as best'
        end
        within "#answer-#{answer2.id}" do
          click_on 'Mark as best'
        end

        expect(page).to have_content('BEST', count: 1)
        within ".answer:first-child" do
          expect(page).to have_content('BEST')
        end
      end
    end

    scenario 'not author tries to mark the answer as best' do
      sign_in(user2)
      visit question_path(question)
      expect(page).to_not have_link 'Mark as best'
    end
  end

  scenario 'Unauthenticated user tries to mark the answer as best' do
    visit question_path(question)
    expect(page).to_not have_link 'Mark as best'
  end
end