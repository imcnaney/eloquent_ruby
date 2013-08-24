# Monkey patching and alias_method - Chapter 24 of Eloquent Ruby
#
# Copyright 2013 Ian McNaney
#
# Some examples inspired by Chapter 24
#
# Summary: Existing classes can be modified by simply reopening them and redefining existing methods or
# adding new ones, or doing anything else like importing modules, changing visibility of methods, or even
# removing them entirely.  Before redefining an existing method alias it to another name and call that as part
# of the redefined method.
#
# Changing the behavior of core parts of Ruby can be catastrophic if done incorrectly, so test.
# Adding methods can inadvertently override them if they already exist.  Someone else might have already added
# a method with that name.
require 'test/unit'

class Widget
  attr_reader :content
  def initialize(content)
    @content = content
  end
end

class String
  alias_method :widget_old_plus, :+
    
  def +(other)
    if other.is_a? Widget 
      self.dup << other.content
    else
      self.widget_old_plus(other)
    end
  end
  
  def with_gusto()
    self.dup << "!"
  end
end

module Squeak
  def squeak()
    "Squeak!"
  end
end

String.__send__(:extend, Squeak) #can also do it by just opening String again and extending normally
String.__send__(:include, Squeak)

class MonkeyPatchTest < Test::Unit::TestCase
  def test_existing_string_addition
    assert_equal("foo bar", "foo " + "bar")
  end
  
  def test_string_plus_widget
    widget = Widget.new("def")
    str = "abc "
    assert_equal("abc def", str + widget)
    assert_equal("abc ", str)
  end
  
  def test_new_method
    str = "Roger"
    assert_equal("Roger!", str.with_gusto)
    assert_equal("Roger", str)
  end
  
  def test_extended_string
    assert_equal("Squeak!", String.squeak)
  end
  
  def test_included_string
    assert_equal("Squeak!", "foo".squeak)
  end
end

#No math for you!
# I initially tried making :+ private but that broke Test::Unit
# I initially tried removing :- and then :/ but those also broke the test.
class Fixnum
  private :*
  remove_method :**
end

class MangledFixnumTest < Test::Unit::TestCase
  def test_private_multiply
    error = assert_raise NoMethodError do
      3 * 5
    end
    assert_match(/private method/, error.message)
  end
  
  def test_removed_power
    error = assert_raise NoMethodError do
      10 ** 5
    end
    assert_match(/undefined method/, error.message)
  end
end