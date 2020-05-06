# frozen_string_literal: true

require_relative 'game'
require_relative 'cards'
require_relative 'dealler'
require_relative 'user'
require_relative 'bank'
require 'terminal-table'
class App
  NAME_FORMAT = /^[а-яА-я]*$/.freeze
  def initialize
    @dealler = Dealler.new
    @game = Game.new
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
    @bank = Bank.new
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
    bet = @user.make_a_bet
    @bank.take_money(bet)
    @dealler.begin_game(Cards.new)
    user_cards = @dealler.give_cards
    @user.take_cards(user_cards)
    @dealler.take_cards
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
      @game.winner(@user.user_cards, @dealler.dealler_cards)
    end
    bank_solution
    finish_game
  rescue ChoiceError
    puts 'Нет такого варианта ответа.'
    puts 'Ставки сделаны, вы не можете выйти из-за стола.'
    retry
  rescue CrashError => e
    puts e.message
    @game.winner(@user.user_cards, @dealler.dealler_cards)
    bank_solution
    finish_game
  end

  def one_more_card
    user_cards = @dealler.give_card
    @user.take_cards(user_cards)
    @dealler.make_solution
    @game.winner(@user.user_cards, @dealler.dealler_cards)
  end

  def skip_a_move
    @dealler.make_solution
    @game.winner(@user.user_cards, @dealler.dealler_cards)
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
    @user.finish_game
    @dealler.finish_game
  end
end

a = App.new
a.start
