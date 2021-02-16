# frozen_string_literal: true

class AddUserAnswerReference < ActiveRecord::Migration[6.0]
  def change
    add_reference(:answers, :user, foreign_key: true)
  end
end
