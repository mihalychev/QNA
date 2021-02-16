class Answer < ApplicationRecord
  include Votable
  include Commentable

  belongs_to :question
  belongs_to :user

  has_many :links, dependent: :destroy, as: :linkable

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  validates :body, presence: true

  scope :sorted_answers, -> { left_joins(:votes).group(:id).order('best desc, count(votes) desc, created_at desc') }

  after_create :notify

  def toggle_best
    if !best?
      Answer.transaction do
        question.answers.where(best: true).update_all(best: false)
        update!(best: true)
      end
    else
      Answer.transaction do
        update!(best: false)
      end
    end
  end

  private

  def notify
    NewAnswerJob.perform_later(self)
  end
end
