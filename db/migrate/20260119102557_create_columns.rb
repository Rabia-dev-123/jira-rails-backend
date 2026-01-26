class CreateColumns < ActiveRecord::Migration[8.1]
  def change
    create_table :columns do |t|
      t.string :title
      t.references :board, null: false, foreign_key: true
      t.integer :position

      t.timestamps
    end
  end
end
