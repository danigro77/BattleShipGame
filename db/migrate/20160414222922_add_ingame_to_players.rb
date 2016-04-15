class AddIngameToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :playing_game_id, :integer
  end
end
