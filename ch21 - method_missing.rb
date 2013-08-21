# method_missing - Chapter 21 of Eloquent Ruby
#
# Copyright 2013 Ian McNaney
#
# Some examples inspired by Chapter 21
#
# Summary:  If a method can't be found anywhere in the target object or its superclasses
# then the method_missing method is invoked.  By default it raises an error, but it can
# be overridden.  If a particular method invocation shouldn't be handled then invoke super.
# Be careful not to refer to a missing method within method_missing or it'll cause infinite recursion.
#
# If a constant isn't there then const_missing will be invoked (class method).  This can be used
# to accept deprecated constants and convert them to the new correct constants (Rake), or it can
# be used to automatically trigger a require the first time a constant is referenced (Rails).
require 'test/unit'

##### method_missing example #####

class Simple
  def method_missing(name, *args)
    super if name == :ignore_me
    "#{name}(#{args.join(', ')})"
  end
end

class SimpleMethodMissingTest < Test::Unit::TestCase
  def test_method_missing
    assert_raise NoMethodError do
      Simple.new.ignore_me(1, 2, 3)
    end
    assert_equal("foo(1, 2, 3)", Simple.new.foo(1, 2, 3))
  end
end

##### const_missing example #####
class ConstMissingTest < Test::Unit::TestCase
  class << self
    def const_missing(name)
      puts "You asked for a #{name} but must have meant Simple"
      Simple
    end
  end
  def test_const_missing
    foo = Foo.new
    assert_equal(Simple, foo.class)
  end
end