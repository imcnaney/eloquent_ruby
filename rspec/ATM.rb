class ATM
  def initialize(bank)
    @bank = bank
  end
  
  def get_balance(account_id)
    if account = @bank.retrieve_account(account_id)
      account.balance
    end
  end
  
  def withdraw(account_id, amount)
    if account = @bank.retrieve_account(account_id)
      account.debit(amount)
    end
  end
  
  def deposit(account_id, amount)
    if account = @bank.retrieve_account(account_id)
      account.debit(-amount)
    end
  end
  
end