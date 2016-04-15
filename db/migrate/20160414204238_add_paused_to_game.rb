class AddPausedToGame < ActiveRecord::Migration
  def change
    add_column :games, :paused, :boolean, default: false
  end
end
