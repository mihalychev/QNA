# frozen_string_literal: true

module Voted
  extend ActiveSupport::Concern

  included do
    before_action :find_votable, only: %i[vote_up vote_down unvote]
  end

  def vote_up
    authorize! :vote_up, @votable
    @votable.vote_up(current_user)
    respond_votable
  end

  def vote_down
    authorize! :vote_down, @votable
    @votable.vote_down(current_user)
    respond_votable
  end

  def unvote
    authorize! :unvote, @votable
    @votable.unvote(current_user)
    respond_votable
  end

  private

  def respond_votable
    respond_to do |format|
      if @votable.save
        format.json do
          render json: { id: @votable.id, resource: @votable.class.name.underscore, total_votes: @votable.total_votes }
        end
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
