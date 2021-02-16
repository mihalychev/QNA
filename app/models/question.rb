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
  validates :body, presence: true

  scope :last_day_questions, -> { where(created_at: (Time.now - 24.hours)..Time.now) }

  after_create :calculate_reputation
  after_create :subscribe_after_create

  def have_best_answer?
    !answers.find_by(best: true).nil?
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

  def calculate_reputation
    ReputationJob.perform_later(self)
  end
end
