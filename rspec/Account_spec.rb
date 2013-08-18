require_relative 'Account'

describe 'Account' do
  before :each do
    @account = Account.new("12345", 100)
  end
  
  it 'should debit properly' do
    @account.debit(50).should == 50
  end
  
  it 'should credit properly' do
    @account.debit(-50).should == 150
  end
  
  it 'should remember its balance' do
    @account.balance.should == 100
    @account.debit(50)
    @account.balance.should == 50
  end
  
  it 'should remember its account id' do
    @account.id.should == "12345"
  end
end