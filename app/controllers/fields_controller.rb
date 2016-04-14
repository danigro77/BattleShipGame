class FieldsController < ApplicationController

  def uncover
    if params[:id]
      field = Field.find(params[:id].to_i)
      if field.update(is_uncovered: true)
        game = field.board.game
        game.change_current_player
        render json: field, serializer: FieldSerializer
      else
        render json: field.errors, status: 400
      end
    else
      render json: ["Param is missing"], status: 404
    end
  end

end