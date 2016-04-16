class Board < ActiveRecord::Base
  SHIPS = {
      aircraft_carrier: {
          length: 5,
          quantity: 1
      },
      battleship: {
          length: 4,
          quantity: 1
      },
      cruiser: {
          length: 3,
          quantity: 1
      },
      destroyer: {
          length: 2,
          quantity: 2
      },
      submarine: {
          length: 1,
          quantity: 2
      }
  }
  validates_presence_of :player_id, :game_id, :total_ship_fields

  before_validation :set_total_ship_fields

  after_create :create_ships
  after_create :set_fields

  belongs_to :player
  belongs_to :game
  has_many :fields
  has_many :ships

  def row(index)
    fields.where(row_index: index).sort_by { |f| f.column_index}
  end

  def column(index)
    fields.where(column_index: index).sort_by { |f| f.row_index}
  end

  def lost?
    set_total_ship_fields == fields.get_hits.length
  end

  def stats
    stats = {}
    stats[player.name] = {
        sunken: 0,
        intact: 0
    }
    ships.each do |ship|
      ship.sunk? ? (stats[player.name][:sunken] += 1) : (stats[player.name][:intact] += 1)
    end
    stats
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
    place_ships
  end

  def set_total_ship_fields
    self.total_ship_fields = SHIPS.values.inject(0) {|result, ship| result += ship[:quantity]*ship[:length]}
  end

  def place_ships
    @all_fields = self.fields
    self.ships.each do |ship|
      slots = get_open_slot(ship.size)
      @all_fields -= slots
      place_ship(slots, ship)
    end
  end

  def place_ship(slots, ship)
    slots.each do |field|
      field.update({is_ship_field: true, ship: ship})
    end
  end

  def get_open_slot(length)
    slots = [@all_fields.sample]
    directions = [:up, :left, :down, :right].shuffle
    directions.each do |direction|
      length.times do |distance|
        return slots if slots.length == length
        next if distance == 0
        current_field = get_field(slots.first, distance, direction)
        if current_field.nil? || current_field.ship
          slots = [slots.first]
          break
        else
          slots << current_field
        end
      end
    end
    get_open_slot(length)
  end

  def get_field(start_field, distance, direction)
    current_slice = case direction
                      when :down, :up
                        column(start_field.column_index)
                      else
                        row(start_field.row_index)
                    end
    start_index = current_slice.index(start_field)
    index = case direction
              when :up, :left
                start_index-distance
              else
                start_index+distance
            end
    (index < 0 || index >= current_slice.length) ? nil : current_slice[index]
  end

  def create_ships
    SHIPS.each do |type, specs|
      specs[:quantity].times do
        ship = Ship.new({
                            ship_type: type,
                            size: specs[:length],
                            board: self
                        })
        unless ship.save
          Rails.errors.add(:ship, "#{type} could not be saved.")
        end
      end
    end
  end

end
