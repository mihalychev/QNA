class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  scope :sorted_answers, ->(question) { where(question: question).order(best: :desc, created_at: :asc) }

  def best?
    best == true
  end

  def set_best(answer)
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
