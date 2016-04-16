class AddNumShipFieldsToBoard < ActiveRecord::Migration
  def change
    add_column :boards, :total_ship_fields, :integer
  end
end
