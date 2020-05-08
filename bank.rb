# frozen_string_literal: true

class Bank
  def take_money(money)
    @money = money
  end

  def give_money
    @money * 2
  end
end
