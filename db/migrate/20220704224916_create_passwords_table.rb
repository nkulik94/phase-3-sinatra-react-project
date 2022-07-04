class CreatePasswordsTable < ActiveRecord::Migration[6.1]
  def change
    create_table :passwords do |t|
      t.string :password
      i.integer :player_id
    end
  end
end
