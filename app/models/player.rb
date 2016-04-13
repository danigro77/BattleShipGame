class Player < ActiveRecord::Base
  validates_uniqueness_of :name
  validates_presence_of :name, :password

  has_many :initialized_games, class_name: "Game", foreign_key: :player1_id
  has_many :invited_games, class_name: "Game", foreign_key: :player2_id
  has_many :current_games, class_name: "Game", foreign_key: :current_player_id
  has_many :won_games, class_name: "Game", foreign_key: :winner_id

  scope :all_online, -> (id) { where(logged_in: true).where.not(id: id).order('LOWER(name) ASC') }

  def all_games
    initialized_games + invited_games
  end

  def active_games
    (initialized_games + invited_games).reject { |game| game.winner_id.present? }
  end

  def inactive_games
    (initialized_games + invited_games).select { |game| game.winner_id.present? }
  end
end
