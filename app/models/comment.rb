class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  belongs_to :user

  validates :body, presence: true

  scope :comments_asc, -> { order(created_at: :asc) }
end