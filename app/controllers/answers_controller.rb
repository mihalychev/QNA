class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_answer, only: %i[ update best destroy ]
  before_action :find_question, only: %i[ update best destroy ]

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.create(answer_params.merge(user: current_user))
  end

  def update
    if current_user.author_of?(@answer)
      @answer.update(answer_params)
    else
      head :forbidden
    end
  end

  def best
    if current_user.author_of?(@question)
      @answer.set_best
    else
      head :forbidden
    end
  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy
    else
      head :forbidden
    end
  end

  private

  def find_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def find_question
    @question = @answer.question
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:id, :name, :url, :_destroy, :user])
  end
end
