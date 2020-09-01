# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    @user = user

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  private

  def guest_abilities
    can :read, :all
    cannot :read, Reward
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :read, Reward
    can :create, [ Question, Answer, Comment ]
    can :update, [ Question, Answer ], user_id: @user.id
    can :destroy, [ Question, Answer ], user_id: @user.id
    can :destroy, ActiveStorage::Attachment, record: { user_id: @user.id }
    can :destroy, Link, linkable: { user_id: @user.id }
    can %i[vote_up vote_down unvote], [ Question, Answer ] do |resource| 
      !@user.author_of?(resource)
    end
    can :best, Answer, question: { user_id: @user.id }
  end
end
