require 'rails_helper'

feature 'User can add reward to question' do
  given(:user) { create(:user) }

  scenario 'User adds link when asks question' do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Title'
    fill_in 'Body', with: 'Body'
    fill_in 'Reward title', with: 'Reward'
    attach_file 'Image', "#{Rails.root}/spec/features/question/files/reward.jpg" 

    click_on 'Ask'

    expect(page).to have_content 'Reward'
    expect(page).to have_css 'img'
  end
end