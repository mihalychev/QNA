class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_answer, only: %i[ update destroy ]

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    flash[:notice] = 'Your answer successfully added.' if @answer.save
  end

  def update
    @answer.update(answer_params)
    @question = @answer.question
  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy
    else
      flash[:alert] = 'You can delete only your answer'
    end
    redirect_to @answer.question
  end

  private

  def find_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
