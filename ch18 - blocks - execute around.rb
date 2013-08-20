# Blocks for "Execute Around" - Chapter 18 of Eloquent Ruby
#
# Copyright 2013 Ian McNaney
#
# Some examples inspired by Chapter 18
#
# Summary: Blocks can be provided to methods that perform boilerplate actions
# like logging to prevent repetition of the boilerplate code
#
# Also included, a mocha example.  "gem install mocha" prior to running this.
require "test/unit"

module LogAround
  def log_around(label)
    begin
      @logger.info("Before #{label}")
      result = yield  #capture and return the result of the block's execution
      @logger.info("After #{label}")
      result
    rescue
      @logger.error("Error during #{label}")
      raise
    end
  end
end

class ExecuteAroundExample
  include LogAround
  
  def initialize(logger)
    @logger = logger
  end
  
  def do_stuff
    log_around("Example") { puts "Hello" }
  end
  
  def do_stuff_that_fails
    log_around("Example Error") { raise "Something Broke" }
  end
end

require 'mocha/setup'

class ExecuteAroundTest < Test::Unit::TestCase
  def test_log_around
    mocklog = mock()
    mocklog.expects(:info).with("Before Example")
    mocklog.expects(:info).with("After Example")
    foo = ExecuteAroundExample.new(mocklog)
    foo.do_stuff
  end
  
  def test_log_around_that_fails
    mocklog = mock()
    mocklog.expects(:info).with("Before Example Error")
    mocklog.expects(:error).with("Error during Example Error")
    foo = ExecuteAroundExample.new(mocklog)
    error = assert_raise RuntimeError do
      foo.do_stuff_that_fails()
    end
    assert_equal("Something Broke", error.message)
  end
end

# We can also yield to blocks in a class's initialize method
class ShoppingCart
  attr_accessor :contents
  def initialize(contents)
    @contents = contents
    yield(self) if block_given?
  end
end

class ShoppingCartTest < Test::Unit::TestCase
  def test_initialize
    cart = ShoppingCart.new(["One", "Two"]) do |c|
      c.contents << "Foo"
      c.contents << "Bar"
    end
    assert_equal(["One", "Two", "Foo", "Bar"], cart.contents)
  end
end