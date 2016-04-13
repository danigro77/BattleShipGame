class Game < ActiveRecord::Base
  validates_presence_of :player1_id, :player2_id, :current_player_id

  before_validation :set_current_player

  belongs_to :player1, class_name: Player
  belongs_to :player2, class_name: Player
  belongs_to :winner, class_name: Player
  belongs_to :current_player, class_name: Player

  private

  def set_current_player
    self.current_player = player1
  end
end
