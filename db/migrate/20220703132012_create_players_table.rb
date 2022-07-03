class CreatePlayersTable < ActiveRecord::Migration[6.1]
  def change
    create_table :players do |t|
      t.string :name
      t.string :username
      t.string :password
    end
  end
end
