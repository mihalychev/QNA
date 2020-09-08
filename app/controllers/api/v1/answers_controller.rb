class Api::V1::AnswersController < Api::V1::BaseController
  before_action :find_answer, only: [ :show, :update, :destroy ]
  before_action :find_question, only: [ :show, :update ]
  
  authorize_resource

  def index
    @answers = Question.find(params[:question_id]).answers
    render json: @answers, each_serializer: AnswersSerializer
  end

  def show
    render json: @answer, serializer: AnswerSerializer
  end
  
  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params.merge(user: current_resource_owner))

    if @answer.save
      render json: @answer, serializer: AnswerSerializer
    else
      render json: { errors: @answer.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @answer.update(answer_params)
      render json: @answer, serializer: AnswerSerializer 
    else
      render json: { errors: @answer.errors.full_messages }, status: :unprocessable_entity
    end
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
    params.require(:answer).permit(:body, links_attributes: [:id, :name, :url, :_destroy, user: current_resource_owner])
  end
end