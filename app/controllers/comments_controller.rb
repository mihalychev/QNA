class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_commentable, only: :create
  after_action :publish_comment, only: :create

  def create
    @comment = @commentable.comments.create(comment_params.merge(user: current_user))
  end

  private

  def publish_comment
    return if @comment.errors.any?
    ActionCable.server.broadcast(
      "question_#{ @commentable.is_a?(Question) ? @commentable.id : @commentable.question.id }_comments",
      @comment
    )
  end

  def find_commentable
    if params[:question_id]
      @commentable = Question.find(params[:question_id])
    elsif params[:answer_id]
      @commentable = Answer.find(params[:answer_id])
    end
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end