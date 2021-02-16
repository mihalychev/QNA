require 'rails_helper'

feature 'User can edit his question' do
  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given!(:question) { create(:question, user: user)  }

  describe 'Authenticated user', js: true do
    context 'author' do
      background do
        sign_in(user)
        visit question_path(question)
      end
  
      scenario 'tries to edit his question' do
        within "#question-#{question.id}" do   
          click_on "Edit question"

          within "#edit-question-#{question.id}" do
            fill_in 'Body', with: 'edited question'
            click_on 'Save'
          end
  
          expect(page).to_not have_content question.body
          expect(page).to have_content 'edited question'
          expect(page).to_not have_selector 'textarea'
        end
      end
  
      scenario 'tries to edit his question with errors' do
        within "#question-#{question.id}" do   
          click_on "Edit question"
          
          within "#edit-question-#{question.id}" do
            fill_in 'Body', with: nil
            click_on 'Save'
          end

          expect(page).to have_content "Body can't be blank"
          expect(page).to have_content question.body
        end
      end

      scenario 'tries to attach files' do
        within "#question-#{question.id}" do  
          click_on "Edit question"
          
          within "#edit-question-#{question.id}" do
            fill_in 'Body', with: 'Body'
            attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
            click_on 'Save'
          end

          expect(page).to have_link 'rails_helper.rb'
          expect(page).to have_link 'spec_helper.rb'
        end
      end
      
      scenario 'tries to delete attached files' do
        within "#question-#{question.id}" do  
          click_on "Edit question"
    
          within "#edit-question-#{question.id}" do
            fill_in 'Body', with: 'Body'
            attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
            click_on 'Save'
          end
    
          click_on "Edit question"
    
          within "#edit-question-#{question.id}" do
            click_on "Delete file"
            click_on 'Save'
          end
          
          expect(page).to_not have_content 'rails_helper.rb'
        end
      end
    end


    scenario "tries to edit other user's question" do
      sign_in(user2)
      visit question_path(question)
      expect(page).to_not have_link 'Edit question'
    end
  end

  scenario 'Unauthenticated user tries to edit question' do
    visit question_path(question)
    expect(page).to_not have_link 'Edit question'
  end
end