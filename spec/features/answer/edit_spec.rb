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

      scenario 'tries to attach files' do
        click_on "Edit"

        within "#answer-#{answer.id}" do
          fill_in 'Body', with: 'Body'
          attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
          click_on 'Save'
  
          expect(page).to have_link 'rails_helper.rb'
          expect(page).to have_link 'spec_helper.rb'
        end
      end

      scenario 'tries to delete attached files' do
        within "#answer-#{answer.id}" do
          click_on "Edit"
          fill_in 'Body', with: 'Body'
          attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
          click_on 'Save'

          click_on "Edit"
          click_on "Delete file"
          click_on 'Save'

          expect(page).to_not have_content 'rails_helper.rb'
        end
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