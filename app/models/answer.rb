# frozen_string_literal: true

class Answer < ApplicationRecord
  include Votable
  include Commentable

  belongs_to :question
  belongs_to :user

  has_many :links, dependent: :destroy, as: :linkable

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  validates :body, presence: true, length: { maximum: 200 }

  scope :sorted_answers, -> { left_joins(:votes).group(:id).order('best desc, count(votes) desc, created_at desc') }

  after_create :notify

  after_create  { question.update(status: 'active') }
  after_destroy { question.update(status: 'unanswered') if question.answers.count.zero? }

  def toggle_best
    best? ? remove_best : set_best
  end

  def created_time
    created_at.strftime('%H:%M')
  end

  def created_date
    created_at.strftime('%d.%m.%Y')
  end

  private

  def set_best
    Answer.transaction do
      question.answers.where(best: true).update_all(best: false)
      update!(best: true)
      question.update(status: 'closed')
    end
  end

  def remove_best
    Answer.transaction do
      update!(best: false)
      question.update(status: 'active')
    end
  end

  def notify
    NewAnswerJob.perform_later(self)
  end
end
