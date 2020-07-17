class AnswersController < ApplicationController
  def new; end

  def edit; end

  private

  def answer
    @answer ||= params[:id] ? Answer.find(params[:id]) : Answer.new
  end

  helper_method :answer

  def answer_params
    params.require(:answer).permit(:body)
  end
end
