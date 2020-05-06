# frozen_string_literal: true

require_relative 'points_calculate'
require 'pry'

class Game
  include PointsCalculate
  @@game_statistic = []
  def winner(user_cards, dealler_cards)
    user_points = calculate_points(user_cards)
    dealler_points = calculate_points(dealler_cards)
    show_results(user_cards, user_points, 'пользователя')
    show_results(dealler_cards, dealler_points, 'деллера')
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
    puts 'Выиграл Пользователь'
    @@game_statistic << 'W'
  end

  def dealler_wins
    puts 'Выиграл Диллер'
    @@game_statistic << 'L'
  end
end

# a.select {|hash| hash.keys.join.include? 'a' }.first['a'] = 'c'
