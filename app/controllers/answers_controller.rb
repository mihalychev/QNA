class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_answer, only: %i[ edit update destroy ]

  def edit; end

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user

    if @answer.save
      redirect_to @question, notice: 'Your answer successfully added.'
    else
      render 'questions/show'
    end
  end

  def update
    if @answer.update(answer_params)
      redirect_to @answer.question
    else
      render :edit
    end
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
