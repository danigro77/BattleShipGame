class Field < ActiveRecord::Base
  validates_presence_of :board_id, :row_index, :column_index

  belongs_to :board
  belongs_to :ship

  scope :get_hits, -> { where("ship_id IS NOT NULL").where(is_uncovered: true) }
end
