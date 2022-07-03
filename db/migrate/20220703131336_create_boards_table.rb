class CreateBoardsTable < ActiveRecord::Migration[6.1]
  def change
    create_table :boards do |t|
      t.string :layout
      t.integer :line_high_score
      t.integer :x_high_score
      t.integer :full_high_score
    end
  end
end
