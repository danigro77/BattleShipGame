class GamesController < ApplicationController

  def new
    if params[:player1] && params[:player2]
      game = Game.new(player1_id: params[:player1].to_i, player2_id: params[:player2].to_i)
      if game.save
        render json: game, serializer: GameSerializer
      else
        render json: game.errors, status: 400
      end
    else
      Rails.errors.add(:game, "params are missing")
      render json: game.errors, status: 404
    end
  end

end