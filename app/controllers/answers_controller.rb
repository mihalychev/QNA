class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_answer, only: %i[ update best destroy ]
  before_action :find_question, only: %i[ update best destroy ]

  after_action :publish_answer, only: :create
  
  include Voted

  authorize_resource

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.create(answer_params.merge(user: current_user))
  end

  def update
    @answer.update(answer_params)
  end

  def best
    @answer.set_best
  end

  def destroy
    @answer.destroy
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

  def publish_answer
    return if @answer.errors.any?
    ActionCable.server.broadcast("question_#{@answer.question_id}", @answer)
  end
end
