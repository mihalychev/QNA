require 'rails_helper'

feature 'User can answer the question', %q{
  As an authenticated user
  I'd like to be able to answer the community question
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'answers the question with valid data' do
      fill_in 'Body', with: 'Answer'
      click_on 'Answer'
      
      expect(current_path).to eq question_path(question)
      within '.answers' do
        expect(page).to have_content 'Answer'
      end
    end

    scenario 'asks a question with attached file' do
      fill_in 'Body', with: 'Answer'
      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Answer'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'answers the question with invalid data' do
      fill_in 'Body', with: nil
      click_on 'Answer'
      expect(page).to have_content "Body can't be blank"
    end
  end

  describe 'Unauthenticated user' do
    scenario 'tries to answer the question' do
      visit question_path(question)
      expect(page).to_not have_content 'Answer the question'
    end
  end
end