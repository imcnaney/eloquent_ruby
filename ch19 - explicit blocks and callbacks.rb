# Explicit blocks and callbacks - Chapter 19 of Eloquent Ruby
#
# Copyright 2013 Ian McNaney
#
# Some examples inspired by Chapter 19
#
# Summary: Blocks can be explicitly listed as method parameters, allowing us to
# save them and run them later as callbacks or lazy initializers
#
# Also demonstrates that blocks are really closures
#
# The lazy loading through a block approach is also good for keeping the class
# general since it doesn't need to know the actual source of the data, other than
# that it comes from the block.
#
# Lambdas and Procs - Proc.new and lambda are not equivalent.  Proc.new behaves like
# an inline block when it contains a return, break, or next.  In case of a return
# it'll attempt to return from the method that created the block.
#
# Lambda behaves more like a portable piece of functionality, and a return simply exits
# the block.  
#
# WARNING - be careful with what's in scope when creating long-lived blocks.
# Be sure to clear any large unnecessary variables before creating the block
# or they won't be garbage collected until the block is destroyed.
require "test/unit"

class CallbackExample
  def initialize
    @callbacks = []
  end
  
  def add_callback(&block)
    @callbacks << block
  end
  
  #the callbacks can take parameters, provided to the call method, 
  #that correspond to variables defined for the block
  def run_callbacks
    @callbacks.each { |callback| callback.call }
  end
end

class CallbackTest < Test::Unit::TestCase
  def test_callbacks
    foo = CallbackExample.new
    sum = 0
    foo.add_callback { sum += 1 }
    foo.add_callback { sum += 2 }
    foo.add_callback { sum += 3 }
    foo.run_callbacks
    assert_equal(6, sum)
  end
end

class LazyLoad
  attr_accessor :thing_one, :thing_two
  
  def initialize(thing_one, thing_two, &block)
    @thing_one = thing_one
    @thing_two = thing_two
    @lazy_loader = block
  end
  
  def expensive_thing
    @expensive_thing ||= @lazy_loader.call
  end
end

class LazyLoadTest < Test::Unit::TestCase
  def test_lazy_load
    lazy = LazyLoad.new("foo","bar") { "Foo" * 100 }
    assert_equal("Foo" * 100, lazy.expensive_thing)
  end
end

# Lambdas
class LambdaExample
  DEFAULT_CALLBACK = lambda do |x|
    x.sum += 1
  end
  
  attr_accessor :sum
  
  def initialize
    @sum = 0
    @callback = DEFAULT_CALLBACK
  end
  
  def go
    @callback.call(self)
  end
end

class LambdaTest < Test::Unit::TestCase
  def test_lambda
    foo = LambdaExample.new
    foo.go
    assert_equal(1, foo.sum)
  end
end