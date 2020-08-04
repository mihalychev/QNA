class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_answer, only: %i[ update best destroy ]
  before_action :set_question, only: %i[ update best destroy ]

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    flash[:notice] = 'Your answer successfully added.' if @answer.save
  end

  def update
    @answer.update(answer_params) if current_user.author_of?(@answer)
  end

  def best
    @answer.set_best(@answer) if current_user.author_of?(@question)
  end

  def destroy    
    @answer.destroy if current_user.author_of?(@answer)
  end

  private

  def find_answer
    @answer = Answer.find(params[:id])
  end

  def set_question
    @question = @answer.question
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
