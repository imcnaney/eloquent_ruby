class Account
  attr_reader :id, :balance
  
  def initialize(id, balance)
    @id = id
    @balance = balance
  end
  
  def debit(amount)
    @balance -= amount
  end
  
end