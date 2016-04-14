class Game < ActiveRecord::Base
  validates_presence_of :player1_id, :player2_id, :current_player_id

  before_validation :set_current_player
  after_create :init_boards

  belongs_to :player1, class_name: Player
  belongs_to :player2, class_name: Player
  belongs_to :winner, class_name: Player
  belongs_to :current_player, class_name: Player
  has_many :boards


  private

  def set_current_player
    self.current_player = player1
  end

  def init_boards
    [player1, player2].each do |player|
      board = Board.new({
          player: player,
          game: self
                        })
      unless board.save
        Rails.errors.add(:board, "Game could not be initialized.")
        Rails.logger.error("Board for Game #{self.id} and Player #{player.id} could not be saved.")
      end
    end
  end
end
