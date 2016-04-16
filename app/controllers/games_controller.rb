class GamesController < ApplicationController

  def current
    if params[:id]
      game = Game.find(params[:id].to_i)
      if game.over?
        render json: game, serializer: StatsSerializer
      elsif game
        render json: game, serializer: GameSerializer
      else
        render json: game.errors, status: 400
      end
    else
      render json: ["Param is missing"], status: 404
    end
  end

  def check_invites
    if params[:player_id]
      games = Game.pending_invitations(params[:player_id]).select {|game| game.both_players_online? && game.not_paused? && game.player2.playing_game == game }
      if games.present?
        puts
        render json: games.map(&:id)
      else
        render json: [], status: 204
      end
    else
      render json: ["Param is missing"], status: 404
    end
  end

  def new
    if params[:player1] && params[:player2]
      game = Game.new(player1_id: params[:player1].to_i, player2_id: params[:player2].to_i)
      if game.save
        player1, player2 = game.player1, game.player2
        data = {playing_game: game}
        if player1.update(data) && player2.update(data)
          render json: game, serializer: GameSerializer
        else
          errors = []
          errors += player1.errors + player2.errors
          render json: errors, status: 400
        end
      else
        render json: game.errors, status: 400
      end
    else
      render json: ["Param is missing"], status: 404
    end
  end

  def pause
    if params[:id]
      game = Game.find(params[:id])
      player1, player2 = game.player1, game.player2
      data = {playing_game: nil}
      if game.update({paused: true})
        if player1.update(data) && player2.update(data)
          render nothing: true, status: 204
        end
      else
        render json: game.errors, status: 400
      end
    else
      render json: ["Param is missing"], status: 404
    end
  end

end