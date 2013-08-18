require_relative 'Bank'
require_relative 'Account'

describe 'Bank' do
  before :each do
    @bank = Bank.new
  end
  
  it 'should remember its accounts' do
    account = Account.new("12345", 500)
    @bank.add_account(account)
    @bank.retrieve_account("12345").should eql(account)
  end
  
  it 'should not make up accounts' do
    @bank.retrieve_account("madeup").should == nil
  end
  
  it 'should replace the existing account when a new one causes an id collision' do
    account1 = Account.new("12345", 100)
    account2 = Account.new("12345", 100)
    @bank.add_account(account1)
    @bank.add_account(account2)
      
    @bank.retrieve_account("12345").should eql(account2)
    @bank.retrieve_account("12345").should_not eql(account1)
  end
  
end