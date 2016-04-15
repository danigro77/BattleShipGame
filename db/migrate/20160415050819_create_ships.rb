class CreateShips < ActiveRecord::Migration
  def change
    create_table :ships do |t|
      t.integer :board_id
      t.string  :ship_type
      t.integer :size
      t.boolean :sunk, default: false

      t.timestamps
    end

    add_column :fields, :ship_id, :integer
  end
end
