# frozen_string_literal: true

class Question < ApplicationRecord
  include Votable
  include Commentable

  belongs_to :user

  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  has_many :subscriptions, dependent: :destroy

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  validates :title, presence: true
  validates :body,  presence: true

  default_scope { order(created_at: :desc) }

  scope :filtered_by_status, lambda { |status = nil|
    case status
    when nil
      all
    when 'active'
      where(status: ['unanswered', 'active']).order(created_at: :desc) 
    else
      where(status: status).order(created_at: :desc)
    end
  }

  scope :filtered_by_starts_with, -> (search) { where("title LIKE ?", "#{search}%") }

  scope :last_day_questions, -> { where(created_at: (Time.now - 24.hours)..Time.now) }

  after_create :subscribe_after_create

  def with_best_answer?
    !answers.find_by(best: true).nil?
  end

  def short_title
    title.truncate(100)
  end

  def created_time
    created_at.strftime('%H:%M')
  end

  def created_date
    created_at.strftime('%d.%m.%Y')
  end

  private

  def subscribe_after_create
    user.subscriptions.find_or_create_by(question_id: id)
  end
end
