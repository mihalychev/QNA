class CreateCategory < ActiveRecord::Migration[6.0]
  def change
    create_table :categories do |t|
      t.string :title, null: false

      t.timestamps
    end

    add_column :questions, :category_id, :integer, foreign_key: true
  end
end
