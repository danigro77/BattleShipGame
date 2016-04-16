class FieldsController < ApplicationController

  def uncover
    if params[:id]
      field = Field.find(params[:id].to_i)
      if field.update(is_uncovered: true)
        field.ship.try(:set_if_sunken)
        field.board.game.change_current_player
        render json: field, serializer: FieldSerializer
      else
        render json: field.errors, status: 400
      end
    else
      render json: ["Param is missing"], status: 404
    end
  end

end