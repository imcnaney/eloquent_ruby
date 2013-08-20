# Mixins - Chapter 16 of Eloquent Ruby
#
# Copyright 2013 Ian McNaney
#
# Some examples inspired by Chapter 16
#
# Summary: Mixins are modules that contain functionality to be shared between
# classes that aren't part of the same inheritance tree
require "test/unit"

module SayLabel
  def say_label
    "My label is: #{@label}"
  end
end

class Widget
  include SayLabel
  def initialize(label)
    @label = label
  end
end

class Screen
  include SayLabel
  def initialize(label)
    @label =  label
  end
end

class MixinTest < Test::Unit::TestCase
  def test_mixin
    widget = Widget.new("Widget")
    assert_equal("My label is: Widget", widget.say_label)
    screen = Screen.new("Screen")
    assert_equal("My label is: Screen", screen.say_label)
  end
end

# To add the mixin methods to the singleton class instead (static methods) do this:
class SingletonExample
  @label = "SingletonExample"
  
  class << self
    include SayLabel
  end
end

#Or shorthand
class SingletonExample2
  extend SayLabel
  @label = "SingletonExample2"
end

class TestSingletonExamples < Test::Unit::TestCase
  def test_singleton_examples
    assert_equal("My label is: SingletonExample", SingletonExample.say_label())
    assert_equal("My label is: SingletonExample2", SingletonExample2.say_label())
  end
end

#To determine whether a given object includes a module use kind_of?
class TestKindOf < Test::Unit::TestCase
  def test_kind_of
    assert(SingletonExample.kind_of?(SayLabel))
    assert(SingletonExample2.kind_of?(SayLabel))
    assert(Widget.new("foo").kind_of?(SayLabel))
  end
end

#Since mixins are injected into the object hierarchy directly above the including clas
#behavior can be overridden
class Override
  include SayLabel
  
  def say_label
    "Not so fast"
  end
end

class TestOverride < Test::Unit::TestCase
  def test_override
    override = Override.new
    assert_equal("Not so fast", override.say_label())
  end
end

#If two mixins contain the same method then the one included last wins
module Collision
  def say_label
    "Collision"
  end
end

class CollisionExample
  include SayLabel
  include Collision
end

class CollisionTest < Test::Unit::TestCase
  def test_collision
    assert_equal("Collision", CollisionExample.new.say_label)
  end
end