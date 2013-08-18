# Singleton methods and Class methods - Chapter 13 of Eloquent Ruby
#
# Copyright 2013 Ian McNaney
#
# Some examples inspired by Chapter 13
#
# Summary: Class methods are actually singleton methods on the Class object.
# Use them to provide alternate constructors, or for functionality that's not specific
# to one instance (like the table name for an ActiveRecord)
#
# Non-class singleton methods are mostly useful for stubs and mocks,
# and not much else.

require 'test/unit'

class Thingy
  attr_reader :foo
  def initialize(foo)
    @foo = foo
  end
  def instance_method
    "Instance method says #{@foo}"
  end
  
  #define a class method here
  class << self
    def original_class_method
      "Original class method"
    end
  end
  
  #Alternate syntax
  def self.alternate
    "Alternate"
  end
end

class Examples < Test::Unit::TestCase
  
  def test_a_singleton_method
    foo = Object.new
    def foo.a_method
      "A method was called"
    end
    assert_equal(foo.a_method, "A method was called")
  end
  
  def test_a_singleton_method_alternate_syntax
    foo = Object.new
    class << foo
      def another_method
        "Another method"
      end
    end
    assert_equal(foo.another_method, "Another method")
  end
  
  def test_getting_the_singleton_class
    foo = Object.new
    singleton_class = class << foo
      self
    end
  end
  
  def test_class_method
    #essentially a static method
    def Thingy.class_method
      "Class method"
    end
    
    thingy = Thingy.new("Bacon")
    assert_equal(thingy.instance_method(), "Instance method says Bacon")
    assert_equal(Thingy.class_method(), "Class method")
    
    #Instances don't know about the class methods since they exist on the Class, not the instance
    assert_raise NoMethodError do
      thingy.class_method()
    end
    
    #But you can get the Class from the instance
    assert_equal(thingy.class.class_method(), "Class method")
    
    assert_equal(Thingy.original_class_method(), "Original class method")
  end
  
  def test_alternate_class_method
    assert_equal(Thingy.alternate, "Alternate")
  end
end