# frozen_string_literal: true

class Cards
  CARD_SUITS = %w[+ <3 ^ <>].freeze
  CARD_VALUES = %w[2 3 4 5 6 7 8 9 10 J Q K A].freeze
  POINTS = [2, 3, 4, 5, 6, 7, 8, 9, 10, 10, 10, 10, 11].freeze
  attr_reader :suit_values, :points
  def initialize
    points = POINTS * 4
    @suit_values = create_cards.flatten.shuffle
    @points = create_cards.flatten.zip(points).to_h
  end

  def create_cards
    points = POINTS * 4
    CARD_SUITS.map do |suit|
      CARD_VALUES.map do |value|
        "#{value} #{suit}"
      end
    end
  end
end
