# frozen_string_literal: true

require_relative 'points_calculate'
class User
  attr_accessor :money, :name, :user_cards
  include PointsCalculate
  def initialize(name)
    @name = name
    @money = 100
    @user_cards = []
  end

  def take_cards(cards)
    @user_cards << cards
    @user_cards.flatten!
    check_crash(@user_cards)
    show_cards_points
  end

  def finish_game
    @user_cards = []
  end

  def make_a_bet
    @money -= 10
    10
  end

  def get_a_win(money)
    @money += money
  end

  private

  def show_cards_points
    puts "Ваши карты #{@user_cards.map(&:keys).flatten.join(' | ')}"
  end
end
