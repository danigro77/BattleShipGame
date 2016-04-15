class Game < ActiveRecord::Base
  validates_presence_of :player1_id, :player2_id, :current_player_id

  before_validation :set_current_player
  after_create :init_boards

  belongs_to :player1, class_name: Player
  belongs_to :player2, class_name: Player
  belongs_to :winner, class_name: Player
  belongs_to :current_player, class_name: Player
  has_many :boards

  scope :pending_invitations, -> (player_id) { where(player2_id: player_id).where('winner_id is null').order('updated_at DESC') }

  def change_current_player
    errors.add(:current_player_id, "could not be saved") unless self.save
  end

  def both_players_online?
    player1.logged_in && player2.logged_in
  end

  def not_paused?
    !paused
  end

  private

  def set_current_player
    if self.current_player == nil || self.current_player == player2
      self.current_player = player1
    else
      self.current_player = player2
    end
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
