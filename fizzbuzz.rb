class FizzBuzz
  #If the number is a multiple of 3 it is "fizz"
  def is_fizz?(number)
    number % 3 == 0
  end
  
  #If the number is a multiple of 5 it is "buzz"
  def is_buzz?(number)
    number % 5 == 0
  end
  
  #Calculate the fizzbuzz result for a particular value
  def fizz_buzz(n)
    fizz = is_fizz?(n)
    buzz = is_buzz?(n)
    if fizz and buzz
      "FizzBuzz"
    elsif fizz
      "Fizz"
    elsif buzz
      "Buzz"
    else
      n
    end
  end
  
  #Return an array containing the results for each value in the specified range
  def fizz_buzz_for_range(from, to)
    results = []
    (from..to).each do |n|
      results.push fizz_buzz(n)
    end
    results
  end

end