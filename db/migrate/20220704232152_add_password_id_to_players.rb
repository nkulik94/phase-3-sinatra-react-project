class AddPasswordIdToPlayers < ActiveRecord::Migration[6.1]
  def change
    add_column :players, :password_id, :integer
  end
end
