require 'rails_helper'

feature 'User can delete link from question' do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user, links_attributes: [{ name: "test", url: "https://test.test" }]) }

  scenario 'User removes link from question', js: true do
    sign_in(user)
    visit question_path(question)
    within "#link-#{question.links.first.id}" do
      click_on 'Delete'
    end
    expect(page).to_not have_link "test", href: "https://test.test"
  end
end