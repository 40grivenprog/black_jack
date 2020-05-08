# frozen_string_literal: true

class User
  attr_accessor :money, :name, :user_cards
  def initialize(name)
    @name = name
    @money = 100
    @user_cards = []
  end

  def make_a_bet
    @money -= 10
    10
  end

  def get_a_win(money)
    @money += money
  end
end
