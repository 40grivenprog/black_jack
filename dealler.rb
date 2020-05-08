# frozen_string_literal: true

require_relative 'deck'
require_relative 'cards'
require_relative 'game'
require_relative 'user'
require_relative 'hand'
require 'pry'
class Dealler
  def make_solution(dealler_hand, deck)
    if dealler_hand.points < 17
      dealler_hand.take_card(deck.give_card)
      'Диллер принял решение взять ещё карту'
    end
  end
end
