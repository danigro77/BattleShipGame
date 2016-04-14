class GamesController < ApplicationController

  def current
    if params[:id]
      game = Game.find(params[:id].to_i)
      if game
        render json: game, serializer: GameSerializer
      else
        render json: game.errors, status: 400
      end
    else
      render json: ["Param is missing"], status: 404
    end
  end

  def new
    if params[:player1] && params[:player2]
      game = Game.new(player1_id: params[:player1].to_i, player2_id: params[:player2].to_i)
      if game.save
        render json: game, serializer: GameSerializer
      else
        render json: game.errors, status: 400
      end
    else
      render json: ["Param is missing"], status: 404
    end
  end

end