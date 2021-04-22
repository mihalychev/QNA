# frozen_string_literal: true

class User < ApplicationRecord
  has_many :votes,         dependent: :destroy
  has_many :answers,       dependent: :destroy
  has_many :comments,      dependent: :destroy
  has_many :questions,     dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def author_of?(resource)
    id == resource.user_id
  end

  def subscribed?(question)
    subscriptions.exists?(question_id: question)
  end
end
