# frozen_string_literal: true

require_relative 'game'
require_relative 'cards'
require_relative 'dealler'
require_relative 'user'
require_relative 'bank'
require_relative 'hand'
require_relative 'deck'
require 'terminal-table'
class App
  NAME_FORMAT = /^[а-яА-я]*$/.freeze
  def initialize
    @dealler = Dealler.new
    @dealler_hand = Hand.new
    @game = Game.new
    @bank = Bank.new
  end

  def start
    enter_name
    loop do
      statistic
      warning_table('Начать игру')
      choice = gets.chomp.to_i
      case choice
      when 1
        start_game
      else
        break
      end
      return 'У вас нет денег' if @user.money.zero?
    end
  end

  private

  def warning_table(param)
    table = Terminal::Table.new do |t|
      t << ["1 - #{param}"]
      t << ['0 - Выйти']
    end
    puts table
  end

  def enter_name
    table = Terminal::Table.new do |t|
      t << ['Введите ваше имя:']
    end
    puts table
    name = gets.chomp
    check_name(name)
    @user = User.new(name)
    @user_hand = Hand.new
  rescue NameError => e
    puts e.message
    retry
  end

  def statistic
    table = Terminal::Table.new do |t|
      t << ["#{@user.name} - #{@user.money}"]
      t << ['L - поражение W - победа']
      t << [@game.class.game_statistic.join(' | ').to_s]
    end
    puts table
  end

  def check_name(name)
    raise NameError, 'Неверный формат имени' unless name.match NAME_FORMAT
  end

  def valid_choice?(variants, choice)
    unless variants.include? choice
      raise ChoiceError, 'Нет такого варианта ответа.'
    end
  end

  def start_game
    @deck = Deck.new
    bet = @user.make_a_bet
    @bank.take_money(bet)
    dealler_cards = @deck.give_cards
    user_cards = @deck.give_cards
    @dealler_hand.take_cards(dealler_cards)
    @user_hand.take_cards(user_cards)
    puts "Ваши карты #{@user_hand.cards.map(&:suit_value).flatten.join(' | ')}"
    puts "Ваши очки: #{@user_hand.points}"
    puts 'Карты диллера - *** | ***'
    puts 'Очки Диллера - ***'
    variants
  end

  def variants
    statistic
    game_table
    choice = gets.chomp.to_i
    valid_choice?((1..3), choice)
    case choice
    when 1
      puts 'Пользователь пропускает ход.'
      skip_a_move
    when 2
      puts 'Пользователь принял решение взять ещё одну карту.'
      one_more_card
    when 3
      puts 'Вскрываемся'
      results
      @game.winner(@user_hand.points, @dealler_hand.points)
    end
    bank_solution
    finish_game
  rescue ChoiceError
    puts 'Нет такого варианта ответа.'
    puts 'Ставки сделаны, вы не можете выйти из-за стола.'
    retry
  rescue CrashError => e
    puts e.message
    @game.winner(@user_hand.points, @dealler_hand.points)
    bank_solution
    finish_game
  end

  def one_more_card
    @user_hand.take_card @deck.give_card
    puts @dealler.make_solution(@dealler_hand, @deck)
    results
    @game.winner(@user_hand.points, @dealler_hand.points)
  end

  def results
    show_results(@user_hand.cards, @user_hand.points, 'пользователя')
    show_results(@dealler_hand.cards, @dealler_hand.points, 'диллера')
  end

  def skip_a_move
    puts @dealler.make_solution(@dealler_hand, @deck)
    results
    @game.winner(@user_hand.points, @dealler_hand.points)
  end

  def bank_solution
    if @game.class.game_statistic.last == 'W'
      win = @bank.give_money
      @user.get_a_win(win)
    end
  end

  def game_table
    table = Terminal::Table.new do |t|
      t << ['1 - Пропустить']
      t << ['2 - Добавить карту']
      t << ['3 - Открыть карты']
    end
    puts table
  end

  def finish_game
    @user_hand.finish_game
    @dealler_hand.finish_game
  end

  def show_results(cards, points, param)
    cards = cards.map(&:suit_value).join(' | ')
    table = Terminal::Table.new do |t|
      t << ["Карты #{param} | #{cards} |"]
      t << ["Очки #{param} #{points}"]
    end
    puts table
  end
end

a = App.new
a.start
