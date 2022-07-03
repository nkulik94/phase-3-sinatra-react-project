class CreatePlayedBoardsTable < ActiveRecord::Migration[6.1]
  def change
    create_table :played_boards do |t|
      t.integer :board_id
      t.integer :player_id
      t.string :unused_nums
      t.integer :turn_count
      t.string :filled_spaces
      t.integer :turns_to_line
      t.integer :turns_to_x
      t.integer :turns_to_full
    end
  end
end
