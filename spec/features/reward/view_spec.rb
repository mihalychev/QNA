require 'rails_helper'

feature 'User can view his rewards' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  
  describe 'Authenticated user' do
    background do
      sign_in(user)
    end
    
    scenario 'tries to view his rewards' do    
      rewards = create_list(:reward, 3, user: user, question: question)
      visit rewards_path
      rewards.each do |r|
        expect(page).to have_content r.question.title
        expect(page).to have_content r.title
        expect(page).to have_css 'img'
      end
    end
  end

  scenario 'Unauthenticated user tries to view rewards' do
    visit questions_path
    expect(page).to_not have_link 'Rewards'
  end

end