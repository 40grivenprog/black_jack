# frozen_string_literal: true

require 'pry'

class Game
  @@game_statistic = []
  def winner(user_points, dealler_points)
    if user_points > 21 || dealler_points > 21
      user_points > 21 ? dealler_wins : user_wins
      nil
    elsif user_points < dealler_points
      dealler_wins
    else
      user_wins
    end
  end

  def self.game_statistic
    @@game_statistic
  end

  private

  def user_wins
    @@game_statistic << 'W'
  end

  def dealler_wins
    @@game_statistic << 'L'
  end
end

# a.select {|hash| hash.keys.join.include? 'a' }.first['a'] = 'c'
