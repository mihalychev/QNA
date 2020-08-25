module Voted
  extend ActiveSupport::Concern

  included do
    before_action :find_votable, only: %i[ vote_up vote_down unvote ]
  end

  def vote_up
    if !current_user&.author_of?(@votable)
      @votable.vote_up(current_user)
      respond_votable
    else
      head :forbidden
    end
  end

  def vote_down
    if !current_user&.author_of?(@votable)
      @votable.vote_down(current_user)
      respond_votable
    else
      head :forbidden
    end
  end

  def unvote
    if !current_user&.author_of?(@votable)
      @votable.unvote(current_user)
      respond_votable
    else
      head :forbidden
    end
  end

  private

  def respond_votable
    respond_to do |format|
      if @votable.save
        format.json { render json: { id: @votable.id, resource: @votable.class.name.underscore, total_votes: @votable.total_votes } }
      else
        format.json { render json: @votable.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  def model_klass
    controller_name.classify.constantize
  end

  def find_votable
    @votable = model_klass.find(params[:id])
  end
end