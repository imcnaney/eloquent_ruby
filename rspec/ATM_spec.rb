require_relative 'ATM'

describe ATM do
  it 'should properly invoke debit on the account with a positive amount for a withdrawal' do
    mock_account = double('Account')
    mock_account.should_receive(:debit).with(50)
    mock_bank = double('Bank')
    mock_bank.should_receive(:retrieve_account).with("12345").and_return(mock_account)
    atm = ATM.new(mock_bank)
    atm.withdraw("12345",50)
  end
  
  it 'should properly invoke debit on the account with a negative amount for a deposit' do
    mock_account = double('Account')
    mock_account.should_receive(:debit).with(-50)
    mock_bank = double('Bank')
    mock_bank.should_receive(:retrieve_account).with("12345").and_return(mock_account)
    atm = ATM.new(mock_bank)
    atm.deposit("12345", 50)
  end
  
  it 'all operations should return nil if the account doesn\'t exist' do
    mock_bank = double('Bank')
    mock_bank.should_receive(:retrieve_account).exactly(3).times.and_return(nil)
    atm = ATM.new(mock_bank)
    atm.deposit("12345",50).should == nil
    atm.withdraw("12345",50).should == nil
    atm.get_balance("12345").should == nil
  end
end