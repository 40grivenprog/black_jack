# frozen_string_literal: true

require_relative 'errors'

class Hand
  attr_reader :cards, :points
  def initialize
    @cards = []
    @points = 0
  end

  def take_cards(cards)
    @cards = cards
    calculate_points
  end

  def take_card(card)
    @cards << card
    calculate_points
  end

  def show_user_cards_points
    "Ваши карты #{@cards.map(&:suit_value).flatten.join(' | ')}"
    "Ваши очки: #{@points}"
  end

  def finish_game
    @cards = []
    @points = 0
  end

  private

  def calculate_points
    @points = @cards.map(&:point).flatten.sum
    @points = check_ace
    raise CrashError, 'Перебор!!!' if @points > 21
  end

  def check_ace
    ace_cards = @cards.select { |card| card.suit_value.include? 'A' }
    if ace_cards.length == 2
      @points - 10
    elsif ace_cards.length == 1
      @points > 21 ? @points - 10 : @points
    else
      @points
    end
  end

  def check_crash
    @points = calculate_points
    raise CrashError, 'Перебор!!!' if @points > 21
  end
end
