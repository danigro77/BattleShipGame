class FieldSerializer < ApplicationSerializer
  attributes :id, :row_index, :column_index, :is_ship_field, :is_uncovered

end