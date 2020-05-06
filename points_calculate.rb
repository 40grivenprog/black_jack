# frozen_string_literal: true

require_relative 'errors'
module PointsCalculate
  private

  def calculate_points(cards)
    points = cards.map(&:values).flatten.sum
    points = check_ace(cards, points)
  end

  def check_ace(cards, points)
    ace_cards = cards.select { |hash| hash.keys.join.include? 'A' }
    if ace_cards.length == 2
      points - 10
    elsif ace_cards.length == 1
      points > 21 ? points - 10 : points
    else
      points
    end
  end

  def check_crash(cards)
    points = calculate_points(cards)
    raise CrashError, 'Перебор!!!' if points > 21
  end

  def show_results(cards, points, param)
    cards = cards.map(&:keys).flatten.join(' | ')
    table = Terminal::Table.new do |t|
      t << ["Карты #{param} | #{cards} |"]
      t << ["Очки #{param} #{points}"]
    end
    puts table
  end
end
