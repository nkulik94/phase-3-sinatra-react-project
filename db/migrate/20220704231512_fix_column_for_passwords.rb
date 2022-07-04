class FixColumnForPasswords < ActiveRecord::Migration[6.1]
  def change
    remove_column :passwords, :player_id
  end
end
