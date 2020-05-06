# frozen_string_literal: true

require_relative 'cards'
require_relative 'game'
require_relative 'user'
require_relative 'points_calculate'
require 'pry'
class Dealler
  include PointsCalculate
  attr_reader :cards, :dealler_cards
  def initialize
    @user_cards = []
    @dealler_cards = []
    @proc = create_proc
  end

  def begin_game(cards)
    @cards = cards
  end

  def give_cards
    cards = []
    2.times do
      cards << @proc.call
    end
    cards
  end

  def give_card
    @proc.call
  end

  def take_cards
    2.times do
      @dealler_cards << @proc.call
    end
    puts 'Карты диллера - *** | ***'
  end

  def take_card
    @dealler_cards << @proc.call
    check_crash(@dealler_cards)
  end

  def make_solution
    dealler_points = calculate_points(@dealler_cards)
    if dealler_points < 17
      puts 'Диллер принял решение взять ещё карту'
      take_card
    end
  end

  def finish_game
    @dealler_cards = []
    @cards = 0
  end

  private

  def create_proc
    proc do
      card = @cards.suit_values[rand(0..@cards.suit_values.length - 1)]
      points = @cards.points[card]
      @cards.suit_values.delete(card)
      { card => points }
    end
  end
end
