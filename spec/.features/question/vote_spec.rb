require 'rails_helper'

feature 'User can vote for an answer' do
  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given(:user3) { create(:user) }
  given(:user4) { create(:user) }
  given(:question) { create(:question, user: user) }

  describe 'Authenticated user', js: true do
    context 'not author' do
      background do
        sign_in(user2)
        visit question_path(question)
      end

      scenario 'tries to vote up' do
        within "#vote-question-#{question.id}" do
          click_on 'Up'
          expect(page).to_not have_content 'Up'
          expect(page).to have_content 'Unvote'
          within('.vote__value') { expect(page).to have_content('1') }
        end
      end
  
      scenario 'tries to vote down' do
        within "#vote-question-#{question.id}" do
          click_on 'Down'
          expect(page).to_not have_content 'Down'
          expect(page).to have_content 'Unvote'
          within('.vote__value') { expect(page).to have_content('-1') }
        end
      end
  
      scenario 'tries to unvote' do
        within "#vote-question-#{question.id}" do
          expect(page).to_not have_content 'Unvote'
          click_on 'Up'
          click_on 'Unvote'
          within('.vote__value') { expect(page).to have_content('0') }
        end
      end
    end

    context 'author' do
      background do
        sign_in(user)
        visit question_path(question)
      end

      scenario 'tries to vote' do
        expect(page).to_not have_link 'Up'
        expect(page).to_not have_link 'Unvote'
        expect(page).to_not have_link 'Down'
      end
    end

    context 'some users not authors' do
      scenario 'tries to vote' do
        sign_in(user2)
        visit question_path(question)
        within "#vote-question-#{question.id}" do
          click_on 'Up'
          within('.vote__value') { expect(page).to have_content('1') }
        end

        click_on 'Logout'

        sign_in(user3)
        visit question_path(question)
        within "#vote-question-#{question.id}" do
          click_on 'Up'
          within('.vote__value') { expect(page).to have_content('2') }
        end

        click_on 'Logout'

        sign_in(user4)
        visit question_path(question)
        within "#vote-question-#{question.id}" do
          click_on 'Down'
          within('.vote__value') { expect(page).to have_content('1') }
        end
      end
    end
  end

  scenario 'Unauthenticated user tries to vote' do
    visit question_path(question)
    expect(page).to_not have_link 'Up'
    expect(page).to_not have_link 'Unvote'
    expect(page).to_not have_link 'Down'
  end
end