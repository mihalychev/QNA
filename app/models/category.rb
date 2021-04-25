# frozen_string_literal: true

class Category < ApplicationRecord
  CATEGORIES = {
    programming: 'Programming',
    mathematics: 'Mathematics'
  }.freeze

  has_many :questions

  validates :title, presence: true

  def self.show_all
    all.map { |c| [c.title, c.id] }
  end
end
