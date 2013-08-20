# Modules - Chapter 15 of Eloquent Ruby
#
# Copyright 2013 Ian McNaney
#
# Some examples inspired by Chapter 15
#
# Summary: Use modules to provide structure and prevent name collisions.
# Modules can contain methods, classes, constants, and other modules.
#
# Note that modules can span files, so it's possible to only import part of
# a module if it's structured that way.
require "test/unit"

module Building
  DEFAULT_TARGET_TEMP = 72.0
  
  def self.say_hello
    "Hello!  I'm a building module."
  end
  
  def mixin_method
    "I can't be called directly on the module.  I can be called on a \ 
    class instance if this module is added as a mixin to that class."
  end
  
  class Elevator
    attr_accessor :shaft_count, :holding_floors
    def initialize(shaft_count, holding_floors)
      @shaft_count = shaft_count
      @holding_floors = holding_floors
    end
  end
  
  class ClimateControl
    attr_accessor :current_temp, :target_temp
    def initialize
      @target_temp = DEFAULT_TARGET_TEMP
    end
  end
  
  module Floor
    class Suite
      attr_accessor :number, :rooms
      def initialize(number, rooms)
        @number = number
        @rooms = rooms
      end
    end
    
    class Room
      attr_accessor :label, :size, :contents
      def initialize(label, size, contents)
        @label = label
        @size = size
        @contents = contents
      end
    end
  end
end

class MixinExample
  include Building
end

class BuildingTest < Test::Unit::TestCase
  def test_module_example
    elevator = Building::Elevator.new(2, [3, 6])
    assert_equal(2, elevator.shaft_count)
    assert_equal([3, 6], elevator.holding_floors)
    
    thermostat = Building::ClimateControl.new()
    assert_equal(Building::DEFAULT_TARGET_TEMP, thermostat.target_temp)
    
    assert_equal("Hello!  I'm a building module.", Building.say_hello)
    
    room = Building::Floor::Room.new("Bob's Office", 500, ["Bob", "Bob's desk", "Bob's chair"])
    assert_equal("Bob's Office", room.label())
    suite = Building::Floor::Suite.new(123, [room])
    assert_equal([room], suite.rooms())
  end
  
  #If we get tired of typing all the prefixes we can just include the module
  include Building::Floor
  def test_include
    room = Room.new("A Room", 500, ["Stuff"])
    assert_equal(500, room.size)
  end
  
  def test_mixin_method
    foo = MixinExample.new
    assert_not_nil(foo.mixin_method())
  end
end

# Modules are just objects, so we can store references to them.  This allows us
# to bundle related behaviors together, set the module once, and then have code
# that doesn't care which module we're using.
# This example is pretty contrived, but presumably this is useful for something. 
module Cow
  class Mouth
    def eat
      "Munch munch"
    end
  end
end

module Pigeon
  class Mouth
    def eat
      "Peck peck"
    end
  end
end

class ModuleReferenceTest < Test::Unit::TestCase
  def test_module_reference
    creature = Cow
    assert_equal("Munch munch", creature::Mouth.new.eat)
    creature = Pigeon
    assert_equal("Peck peck", creature::Mouth.new.eat)
  end
end