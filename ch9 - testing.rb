# Testing - Chapter 9 of Eloquent Ruby
#
# Copyright 2013 Ian McNaney
#
# Some examples inspired by Chapter 9
#
# See also: fizzbuzz.rb and fizzbuzz_spec.rb
#
# Test:Unit and RSpec
require 'pp'
require 'test/unit'
require_relative 'fizzbuzz'

########## Test::Unit ###########
class FizzBuzzTests < Test::Unit::TestCase
  #Called before each test method.  It's not actually necessary here
  def setup()
    @fizzbuzz = FizzBuzz.new()
  end
  
  #If we needed to clean anything up after a test is run we'd do it here
  def teardown()
  end
  
  def test_zero_result()
    result = @fizzbuzz.fizz_buzz(0)
    assert_equal("FizzBuzz", result)
  end
  
  def test_negative_ten_to_ten()
    expected = ["Buzz", "Fizz", -8, -7, "Fizz", "Buzz", -4, "Fizz", -2, -1, "FizzBuzz", 1, 2, "Fizz", 4, "Buzz", "Fizz", 7, 8, "Fizz", "Buzz"]
    result = @fizzbuzz.fizz_buzz_for_range(-10,10)
    assert_equal(expected, result)
    
    assert(result.include?(-7), "-7 expected")
  end
  
  def test_multiples_of_3_but_not_5
    expected = "Fizz"
    assert_equal(expected, @fizzbuzz.fizz_buzz(3))
    assert_equal(expected, @fizzbuzz.fizz_buzz(6))
    assert_equal(expected, @fizzbuzz.fizz_buzz(9))
    assert_equal(expected, @fizzbuzz.fizz_buzz(-3))
    assert_equal(expected, @fizzbuzz.fizz_buzz(-6))
    assert_equal(expected, @fizzbuzz.fizz_buzz(-9))
  end
  
  def test_multiples_of_5_but_not_3
    expected = "Buzz"
    assert_equal(expected, @fizzbuzz.fizz_buzz(5))
    assert_equal(expected, @fizzbuzz.fizz_buzz(10))
    assert_equal(expected, @fizzbuzz.fizz_buzz(20))
    assert_equal(expected, @fizzbuzz.fizz_buzz(25))
    assert_equal(expected, @fizzbuzz.fizz_buzz(-5))
    assert_equal(expected, @fizzbuzz.fizz_buzz(-10))
    assert_equal(expected, @fizzbuzz.fizz_buzz(-20))
    assert_equal(expected, @fizzbuzz.fizz_buzz(-25))
  end
  
  def test_multiples_of_3_and_5
    expected = "FizzBuzz"
    assert_equal(expected, @fizzbuzz.fizz_buzz(15))
    assert_equal(expected, @fizzbuzz.fizz_buzz(30))
    assert_equal(expected, @fizzbuzz.fizz_buzz(45))
    assert_equal(expected, @fizzbuzz.fizz_buzz(-45))
    assert_equal(expected, @fizzbuzz.fizz_buzz(-30))
    assert_equal(expected, @fizzbuzz.fizz_buzz(-15))
    assert_equal(expected, @fizzbuzz.fizz_buzz(0))
  end
  
  def test_multiples_of_neither_3_nor_5
    assert_equal(1, @fizzbuzz.fizz_buzz(1))
    assert_equal(2, @fizzbuzz.fizz_buzz(2))
    assert_equal(4, @fizzbuzz.fizz_buzz(4))
    assert_equal(7, @fizzbuzz.fizz_buzz(7))
    assert_equal(-1, @fizzbuzz.fizz_buzz(-1))
    assert_equal(-2, @fizzbuzz.fizz_buzz(-2))
    assert_equal(-4, @fizzbuzz.fizz_buzz(-4))
    assert_equal(-7, @fizzbuzz.fizz_buzz(-7))
  end
  
  def test_very_large_value
    assert_equal("FizzBuzz", @fizzbuzz.fizz_buzz(15000000000000000000))
  end
  
  #There are other assertions like assert_not_equal, assert_nil, assert_not_nil
  #assert_instance_of, assert_raise, assert_nothing_thrown
end
