class PlayersController < ApplicationController

  before_action :clean_params, only: [:current, :new]

  # current GET  /api/players/current(.:format) players#current
  def current
    if valid_data
      player = Player.find_by(@player_data)
      if player
        player.logged_in = true
        if player.save
          render json: player, serializer: PlayerSerializer
        else
          render json: player.errors, status: 400
        end
      else
        render json: ["Player not found"], status: 404
      end
    else
      render json: @errors, status: 400
    end
  end

  # GET  /api/players/online/:id(.:format) players#online
  def online
    players = Player.get_online(params[:id])
    if players
      render json: players, each_serializer: PlayerSerializer
    else
      render json: {players: ["data not found."]}, status: 404
    end
  end

  # new POST  /api/players/new(.:format)     players#new
  def new
    player = Player.new(@player_data)
    player.logged_in = true
    if player.save
      render json: player, serializer: PlayerSerializer
    else
      render json: player.errors, status: 400
    end
  end

  # PUT  /api/players/logout/:id(.:format) players#logout
  def logout
    player = Player.find(params[:id])
    if player.update({logged_in: false})
      render nothing: true, status: 200
    else
      render json: player.errors, status: 400
    end
  end

  private

  def clean_params
    @player_data = params['player'].is_a?(Hash) ? player_params : JSON.parse(params['player'])
  end
  def player_params
    params.require(:player).permit(:name, :password)
  end
  def valid_data
    @errors = []
    @errors << "Fill out you name" unless @player_data[:name] || @player_data['name']
    @errors << "Fill out you password" unless @player_data[:password] || @player_data['password']
    @errors.length == 0
  end

end