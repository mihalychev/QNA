class AddReferencesAndDefaultData < ActiveRecord::Migration[6.0]
  def change
    add_reference(:answers, :question, foreign_key: true)

    change_column_default(:answers, :correct, from: nil, to: false)
  end
end
