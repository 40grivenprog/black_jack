# frozen_string_literal: true

class Card
  attr_reader :suit_value, :point
  def initialize(card_suit, card_value, point)
    @point = point
    @suit_value = "#{card_value} #{card_suit}"
  end
end
