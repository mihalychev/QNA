require 'rails_helper'

feature 'User can delete answer' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, user: user, question: question) }
  given(:user2) { create(:user) }

  scenario 'Authenticated user tries to delete his own answer' do
    sign_in(user)
    visit question_path(question)
    click_on 'Delete answer'
    expect(page).to_not have_content answer.body
  end

  scenario 'Authenticated user tries to delete answer which belongs to another user' do
    sign_in(user2)
    visit question_path(question)
    expect(page).to_not have_css 'button_delete-answer'
  end

  scenario 'Unauthenticated user tries to delete answer' do
    visit question_path(question)
    expect(page).to_not have_css 'button_delete-answer'
  end
end