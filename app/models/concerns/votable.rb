# frozen_string_literal: true

module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def vote_up(user)
    unvote(user)
    make_vote(user, 1) unless voted_by?(user)
  end

  def vote_down(user)
    unvote(user)
    make_vote(user, -1) unless voted_by?(user)
  end

  def total_votes
    votes.sum(:value)
  end

  def voted_by_with_value?(user, value)
    votes.where(user: user, value: value).exists?
  end

  def unvote(user)
    votes.find_by(user: user).destroy if voted_by?(user)
  end

  private

  def make_vote(user, value)
    votes.create({ user: user, value: value })
  end

  def voted_by?(user)
    votes.where(user: user).exists?
  end
end
