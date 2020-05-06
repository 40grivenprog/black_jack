# frozen_string_literal: true

class Bank
  def take_money(money)
    puts "Банк получил #{money}$"
    @money = money
  end

  def give_money
    puts "Банк отдаёт выигрыш #{@money * 2}$"
    @money * 2
  end
end
