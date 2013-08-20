# Class instance variables - Chapter 14 of Eloquent Ruby
#
# Copyright 2013 Ian McNaney
#
# Some examples inspired by Chapter 14
#
# Summary: Class variables (@@foo) behave oddly.  Don't use them.
# Use class instance variables instead.
require "test/unit"

class Example
  @default_value = 3
  
  def self.default_value=(value)
    @default_value = value
  end
  
  def self.default_value
    @default_value
  end
end

class ExampleTest < Test::Unit::TestCase
  def test_class_instance_variable
    assert_equal(Example.default_value(), 3)
    Example.default_value = 5
    assert_equal(Example.default_value, 5)
  end
end

#another way to define class instance variables:
class ExampleTwo
  @default_value = 3
  
  class << self
    attr_accessor :default_value
  end
end

class ExampleTwoTest < Test::Unit::TestCase
  def test_example_two
    assert_equal(ExampleTwo.default_value, 3)
    ExampleTwo.default_value = 5
    assert_equal(ExampleTwo.default_value, 5)
  end
end
