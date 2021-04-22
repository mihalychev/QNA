class AddStatusToQuestion < ActiveRecord::Migration[6.0]
  def change
    add_column :questions, :status, :string, default: 'unanswered'
  end
end
