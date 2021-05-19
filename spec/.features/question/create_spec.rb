require 'rails_helper'
feature 'User can create question', %q{
  In order to get answer from a community
  As an authenticated user
  I'd like to be able to ask the question
} do

  given(:user) { create(:user) }
  given!(:category) { create(:category) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
  
      visit questions_path
      click_on 'Ask question'
    end
  
    scenario 'asks a question' do
      fill_in 'Title', with: 'Title'
      fill_in 'Body', with: 'Body'
      select category.title, from: 'Category'
      click_on 'Ask'
  
      expect(page).to have_content 'Your question successfully created.'
      
      within '#question-title' do
        expect(page).to have_content 'Title'
      end

      within '#question-body' do
        expect(page).to have_content 'Body'
      end
    end

    scenario 'asks a question with attached file' do
      fill_in 'Title', with: 'Title'
      fill_in 'Body', with: 'Body'
      select category.title, from: 'Category'
      attach_file 'Choose file', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Ask'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  
    scenario 'asks a question with errors' do
      click_on 'Ask'

      expect(page).to have_content "Title can't be blank"
    end  
  end

  describe 'Unauthenticated user' do
    scenario 'tries to ask a question' do
      visit questions_path
  
      expect(page).to_not have_content 'Ask question'
    end
  end

  context 'multiple sessions' do
    scenario "question appears on another user's page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit questions_path
      end

      Capybara.using_session('guest') do
        visit questions_path
      end

      Capybara.using_session('user') do
        click_on 'Ask question'
        fill_in 'Title', with: 'Title'
        fill_in 'Body', with: 'Body'
        select category.title, from: 'Category'
        click_on 'Ask'

        within '#question-title' do
          expect(page).to have_content 'Title'
        end
        within '#question-body' do
          expect(page).to have_content 'Body'
        end
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Title'
      end
    end
  end
end