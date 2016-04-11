class PlayersController < ApplicationController

  before_action :clean_params

  # current GET  /api/players/current(.:format) players#current
  def current
    if valid_data
      player = Player.find_by(@player_data)
      if player
        render json: player, serializer: PlayerSerializer
      else
        render json: ["Player not found!"], status: 404
      end
    else
      render json: @errors, status: 400
    end
  end

  # new POST  /api/players/new(.:format)     players#new
  def new
    player = Player.new(@player_data)
    if player.save
      render json: player, serializer: PlayerSerializer
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
    @errors << "Fill out you name!" unless @player_data[:name] || @player_data['name']
    @errors << "Fill out you password!" unless @player_data[:password] || @player_data['password']
    @errors.length == 0
  end

end