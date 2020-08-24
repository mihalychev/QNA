module Votable
  extend ActiveSupport::Concern
  
  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def vote_up(user)
    make_vote(user, 1) unless votes.where(user: user).exists?
  end

  def vote_down(user)
    make_vote(user, -1) unless votes.where(user: user).exists?
  end

  def unvote(user)
    votes.find_by(user: user).destroy if votes.where(user: user).exists?
  end

  def total_votes
    votes.sum(:value)
  end

  private

  def make_vote(user, value)
    votes.create({ user: user, value: value })
  end
end