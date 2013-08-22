# method_missing for APIs - Chapter 23 of Eloquent Ruby
#
# Copyright 2013 Ian McNaney
#
# Some examples inspired by Chapter 23
#
# Summary: When there are many methods that are variations on a theme don't just write all the methods,
# use method_missing to fake it.  The following example is pretty pointless, but it's
# less pointless for things like ActiveRecord's find_by_<blah_and_moreblah> methods.
#
# WARNING: Without additional effort to redefine respond_to? it won't know about these fake methods and
# code that relies on respond_to? being accurate won't work properly.
require 'test/unit'

class Contrived
  def self.method_missing(name, *args)
    name_str = name.to_s
    super unless /^print_\w+$/ =~ name_str
    name_str.sub("print_", "")
  end
  
  def self.respond_to?(name)
    name_str = name.to_s
    return true if /^print_\w+$/ =~ name_str
    super
  end
end

class ContrivedAPITest < Test::Unit::TestCase
  def test_contrived_api
    assert_equal("foo", Contrived.print_foo)
    assert_equal("bar", Contrived.print_bar)
    assert_raise NoMethodError do
      Contrived.flail_about
    end
  end
  
  def test_respond_to
    assert(Contrived.respond_to?(:print_foo))
    assert(Contrived.respond_to?(:print_bar))
    assert(!Contrived.respond_to?(:flail_about))
  end
end

## A real example of this behavior is Openstruct.  It wraps a hash
# to behave like an object, so rather than using hash['foo'] it understands hash.foo
require 'ostruct'

class OpenStructTest < Test::Unit::TestCase
  def test_open_struct
    bob = OpenStruct.new
    bob.thing = "thing"
    bob.another_thing = "another thing"
    assert_equal("thing", bob.thing)
    assert_equal("another thing", bob.another_thing)
  end
end

