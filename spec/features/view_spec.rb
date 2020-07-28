require 'rails_helper'

feature 'User can view questions and answers' do
  given(:question) { create(:question) }
  given(:answer) { create(:answer, question: question) }

  scenario 'User views all questions' do
    questions = create_list(:question, 3, :rand)

    visit questions_path

    questions.each do |q|
      expect(page).to have_content q.title
    end
  end

  scenario 'User views question answers' do    
    question.answers = create_list(:answer, 3, :rand)

    visit question_path(question)
    
    question.answers.each do |a|
      expect(page).to have_content a.body
    end
  end
end