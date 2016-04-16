class Ship < ActiveRecord::Base
  validates_presence_of :board_id, :ship_type, :size

  has_many :fields
  belongs_to :board

  def set_if_sunken
    if fields.map(&:is_uncovered).uniq == [true]
      self.update({sunk: true})
    end
  end

end
