# frozen_string_literal: true

class AddReference < ActiveRecord::Migration[6.0]
  def change
    add_reference(:answers, :question, foreign_key: true)
  end
end
