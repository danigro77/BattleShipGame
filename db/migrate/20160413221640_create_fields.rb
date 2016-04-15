class CreateFields < ActiveRecord::Migration
  def change
    create_table :fields do |t|
      t.integer :board_id
      t.integer :row_index
      t.integer :column_index
      t.boolean :is_ship_field, default: false
      t.boolean :is_uncovered, default: false

      t.timestamps
    end
  end
end
