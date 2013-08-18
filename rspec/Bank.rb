class Bank
  def initialize()
    @accounts = {}
  end
  
  #if the account already exists it will be replaced
  def add_account(account)
    @accounts[account.id] = account
  end
  
  def retrieve_account(account_id)
    @accounts[account_id]
  end
end