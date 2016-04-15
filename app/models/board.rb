class Board < ActiveRecord::Base
  validates_presence_of :player_id, :game_id

  after_create :set_fields

  belongs_to :player
  belongs_to :game
  has_many :fields

  def row(index)
    fields.where(row_index: index)
  end

  def column(index)
    fields.where(column_index: index)
  end


  private

  def set_fields
    10.times do |i|
      10.times do |j|
        field = Field.new({
            board: self,
            row_index: i,
            column_index: j
            })
        unless field.save
          Rails.errors.add(:fields, "Field #{i}/#{j} for board #{self.id} was not saved")
          Rails.logger.error("Field #{i}/#{j} for board #{self.id} was not saved")
        end
      end
    end
  end
end
