class AddLoggedInToPlayer < ActiveRecord::Migration
  def change
    add_column :players, :logged_in, :boolean
  end
end
