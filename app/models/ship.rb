class Ship < ActiveRecord::Base
  validates_presence_of :board_id, :ship_type, :size

  has_many :fields
  belongs_to :board

end
