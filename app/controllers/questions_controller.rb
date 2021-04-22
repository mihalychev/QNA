# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :find_question, only: %i[show edit update destroy]

  after_action :publish_question, only: [:create]

  include Voted

  authorize_resource

  def index
    @search = params[:search] || ''
    @status = params[:status]
    @questions = Question.filtered_by_status(@status).filtered_by_starts_with(@search)
  end

  def show
    @answer = Answer.new
    @answer.links.new
  end

  def new
    @question = Question.new
    @question.links.new
  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    @question.update(question_params)
  end

  def destroy
    @question.destroy
    redirect_to questions_path
  end

  private

  def find_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(
      :title,
      :body,
      files: [],
      links_attributes: [:id, :name, :url, :_destroy, { user: current_user }]
    )
  end

  def publish_question
    return if @question.errors.any?

    ActionCable.server.broadcast(
      'questions',
      ApplicationController.render(
        partial: 'questions/question_list_item',
        locals: { question: @question }
      )
    )
  end
end
