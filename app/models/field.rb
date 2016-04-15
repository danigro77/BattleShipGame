class Field < ActiveRecord::Base
  validates_presence_of :board_id, :row_index, :column_index

  belongs_to :board
  belongs_to :ship

end
