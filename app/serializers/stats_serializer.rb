class StatsSerializer < ApplicationSerializer
  attributes :id, :winner, :loser, :this_game, :all_games

  def winner
    object.winner.name
  end

  def loser
    object.loser.name
  end

  def this_game
    stats = {}
    object.boards.map(&:stats).each {|item| stats[item.keys.first] = item[item.keys.first] }
    stats
  end

  def all_games
    win, los = object.winner, object.loser
    games = Game.games_played_together(object.winner, object.loser)
    stats = {}
    games.each do |game|
      if game.paused
        stats[:paused] ||= 0
        stats[:paused] += 1
      elsif game.winner == win
        stats[win.name] ||= 0
        stats[win.name] += 1
      else
        stats[los.name] ||= 0
        stats[los.name] += 1
      end

    end
    stats[:total] = games.length
    stats
  end

end