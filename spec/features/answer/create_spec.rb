require 'rails_helper'

feature 'User can answer the question', %q{
  As an authenticated user
  I'd like to be able to answer the community question
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'answers the question' do
      fill_in 'Body', with: 'Answer'
      click_on 'Answer'
      expect(page).to have_content 'Your answer successfully added.'
    end

    scenario 'answers the question with errors' do
      click_on 'Answer'
      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user tries to answer the question' do
    visit question_path(question)
    expect(page).to_not have_css 'form'
  end
end