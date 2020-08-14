class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  has_many :links, dependent: :destroy, as: :linkable

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  validates :body, presence: true

  scope :sorted_answers, -> { order(best: :desc, created_at: :asc) }

  def set_best
    if !best?
      Answer.transaction do
        question.answers.where(best: true).update_all(best: false)
        update!(best: true)
      end
    else
      return      
    end
  end
end
