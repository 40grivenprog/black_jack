# frozen_string_literal: true

require_relative 'cards'
CARD_SUITS = %w[+ <3 ^ <>].freeze
CARD_VALUES = %w[2 3 4 5 6 7 8 9 10 J Q K A].freeze
POINTS = [2, 3, 4, 5, 6, 7, 8, 9, 10, 10, 10, 10, 11].freeze
class Deck
  attr_reader :cards, :mixed_cards
  def initialize
    @cards = create_cards
    @proc = create_proc
  end

  def create_cards
    CARD_SUITS.map do |suit|
      CARD_VALUES.map do |value|
        point = get_point(value)
        Card.new(suit, value, point)
      end
    end.flatten.shuffle
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

  private

  def get_point(value)
    value[/\d+/] ? value[/\d+/].to_i : 10
  end

  def create_proc
    proc do
      card = @cards.last
      @cards.delete(card)
      card
    end
  end
end
