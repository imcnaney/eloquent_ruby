# method_missing for delegation - Chapter 22 of Eloquent Ruby
#
# Copyright 2013 Ian McNaney
#
# Some examples inspired by Chapter 22
#
# Summary:  Say we want to wrap some functionality around an object's methods.  We can create another class
# with a method_missing implementation that performs this functionality and then delegates to the original
# object.
#
# delegate.rb includes some delegation classes to simplify this and make it more robust, but these examples
# show how it basically works.
#
# WARNING - if the object actually does have the method, like to_s, then method_missing won't be invoked.
# To avoid this use BasicObject as the class's parent (new in 1.9)

require 'test/unit'

class Tomato
  def stain_shirt
    "My shirt is ruined!"
  end
  def grade_performance(score)
    case score
      when 1..5 then "splat"
      when 6..10 then "no splat"
    end
  end
end

class Pomegranite
  def stain_shirt
    "That's never coming out."
  end
  def grade_performance(score)
    "You could kill somebody with that!"
  end
end

class AudienceMember
  def initialize(fruit)
    @fruit = fruit ||= Tomato.new
  end
  def method_missing(name, *args)
    @fruit.__send__(name, *args)
  end
end

class AudienceMemberTest < Test::Unit::TestCase
  def test_with_tomato
    person = AudienceMember.new(Tomato.new)
    assert_equal("My shirt is ruined!", person.stain_shirt)
    assert_equal("splat", person.grade_performance(3))
    assert_equal("no splat", person.grade_performance(7))
    assert_raise NoMethodError do
      person.method_that_doesnt_exist
    end
  end
  
  def test_with_pomegranite
    person = AudienceMember.new(Pomegranite.new)
    assert_equal("That's never coming out.", person.stain_shirt)
    assert_equal("You could kill somebody with that!", person.grade_performance(2))
  end
  
  def test_with_nil
    person = AudienceMember.new(nil)
    assert_equal("My shirt is ruined!", person.stain_shirt)  #should have a Tomato by default.
  end
end

#Maybe we want to delegate selectively.  We could use multiple collections of method symbols to delegate to
#different objects
class SelectiveDelegation
  TO_DELEGATE = [:grade_performance]
  def initialize(fruit)
    @fruit = fruit ||= Tomato.new
  end
  def method_missing(name, *args)
    if TO_DELEGATE.include?(name)
      @fruit.__send__(name, *args)
    else
      super
    end
  end
end

class SelectiveDelegationTest < Test::Unit::TestCase
  def test_selective_delegation
    sut = SelectiveDelegation.new(Tomato.new)
    assert_equal("splat", sut.grade_performance(3))
    assert_raise NoMethodError do
      sut.stain_shirt
    end
  end
end

#BasicObject example that will delegate to_s
class BasicDelegator < BasicObject
  def initialize(fruit)
    @fruit = fruit
  end
  def method_missing(name, *args)
    @fruit.__send__(name, *args)
  end
end

class BasicDelegatorTest < Test::Unit::TestCase
  def test_delegation_from_basic_object
    sut = BasicDelegator.new(Tomato.new)
    assert_match(/Tomato/, sut.to_s)
  end
end