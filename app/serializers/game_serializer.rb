class GameSerializer < ApplicationSerializer
  attributes :id, :current_player_id
  has_one :player1, serializer: PlayerSerializer
  has_one :player2, serializer: PlayerSerializer
  has_many :boards, serializer: BoardSerializer


end