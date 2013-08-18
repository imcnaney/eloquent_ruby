require_relative 'fizzbuzz'

describe FizzBuzz do
  before :each do
    @fizzbuzz = FizzBuzz.new
  end
  
  it 'should calculate -10 to 10 correctly' do
    expected = ["Buzz", "Fizz", -8, -7, "Fizz", "Buzz", -4, "Fizz", -2, -1, "FizzBuzz", 1, 2, "Fizz", 4, "Buzz", "Fizz", 7, 8, "Fizz", "Buzz"]
    @fizzbuzz.fizz_buzz_for_range(-10,10).should == expected
  end
end