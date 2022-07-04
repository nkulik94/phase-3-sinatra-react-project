class RemovePasswordColumnFromPlayers < ActiveRecord::Migration[6.1]
  def change
    remove_column :players, :password
  end
end
