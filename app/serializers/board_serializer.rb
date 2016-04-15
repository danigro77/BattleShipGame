class BoardSerializer < ApplicationSerializer
  attributes :id, :player_id, :board_fields
  # has_many :fields

  def board_fields
    tmp = {}
    object.fields.each do |f|
      tmp[f.row_index] ||= []
      tmp[f.row_index] << {
          id: f.id,
          row_index: f.row_index,
          column_index: f.column_index,
          is_ship_field: f.is_ship_field,
          is_uncovered: f.is_uncovered
      }
    end
    tmp
  end


end