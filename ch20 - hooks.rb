# Explicit blocks and callbacks - Chapter 20 of Eloquent Ruby
#
# Copyright 2013 Ian McNaney
#
# Some examples inspired by Chapter 20
#
# Summary: Ruby provides hooks that you can use to learn about events such as
# a new subclass being defined (useful for keeping a list of subclasses to delegate
# to.
#
# Also modules have a hook for when they're included.  Useful for injecting class
# methods into the including class at the same time, avoiding an additional module
# that the including class would extend.
#
# We can call at_exit to register code blocks to be run before the runtime exits.  
# These run LIFO
#
# method_missing will be covered in a future chapter
# if you're into logging absolutely everything see set_trace_func
require 'test/unit'

############### subclass examples ###################

class MyClass
#  extend SubclassAware

  @subclasses = []

  class << self
    attr_reader :subclasses
  
    def inherited(subclass)
      MyClass.subclasses << subclass
    end
  end
end

class MySubclass < MyClass
end

class MySubSubclass < MySubclass
end

class InheritedHookTest < Test::Unit::TestCase
  #observe that both MySubclass and MySubSubclass are included in MyClass's subclasses
  #MySubclass inherits the hook that refers to MyClass.subclasses so when it is subclassed it adds its
  #subclass to MyClass's list.
  #If we use the mixin defined above then it'll simply not register MySubSubclass since MySubclass doesn't
  #have a @subclasses array, and the inherited method does nothing in that case.
  def test_inherited_hook
    assert_equal([MySubclass, MySubSubclass], MyClass.subclasses)
  end
end


#If subclasses have their own inherited hook then only the first (lowest) one will be invoked

class A
  @subclasses = []
  
  class << self
    attr_reader :subclasses
  
    def inherited(subclass)
      A.subclasses << subclass
    end
  end
end

class B < A
  @subclasses = []
  
  class << self
    attr_reader :subclasses
 
    def inherited(subclass)
      B.subclasses << subclass
    end
  end
end

class C < B
end

class SubClassWithHookTest < Test::Unit::TestCase
  def test_subclass_with_hook
    assert_equal([B], A.subclasses())
    assert_equal([C], B.subclasses())
  end
end


#Unless we explicitly invoke the superclass's inherited method from the subclass's
#inherited method
class X
  @subclasses = []
    
  class << self
    attr_accessor :subclasses
    
    def inherited(subclass)
      X.subclasses << subclass
    end
  end
end

class Y < X
  @subclasses = []
    
  class << self
    attr_accessor :subclasses
    
    def inherited(subclass)
      Y.subclasses << subclass
      Y.superclass().inherited(subclass)
    end
  end
end

class Z < Y
end

class SubClassWithHookAndSuperclassCallTest < Test::Unit::TestCase
  def test_subclass_hook_with_superclass_call
    assert_equal([Y, Z], X.subclasses)
    assert_equal([Z], Y.subclasses)
  end
end


############### module example ###################
# Let's be nice and auto-extend the including class so that class methods
# are also added without having to explicitly extend with the ClassMethods module
module MyModule
  module ClassMethods
    def class_method
      "Class method"
    end
  end
  
  def instance_method
    "Instance method"
  end
  
  def self.included(including_class)
    including_class.extend(ClassMethods)
  end
end

class AutoExtendExample
  include MyModule
end

class AutoExtendTest < Test::Unit::TestCase
  def test_auto_extend
    assert_equal("Class method", AutoExtendExample.class_method)
    assert_equal("Instance method", AutoExtendExample.new.instance_method)
  end
end



############### at_exit ###################
# takes a block.  if called multiple times the blocks run in LIFO order
at_exit {puts "Cruel world..."}
at_exit {puts "Farewell"}


# Let's revisit the inherited method, but this time use a module or two
module DirectSubclassAware
  attr_reader :subclasses
  def inherited(subclass)
    @subclasses << subclass
  end
end

#Note that if some subclasses redefine inherited (for example by extending DirectSubclassAware)
#Then it won't necessarily make the superclass call, and so subclasses of that class may not be passed
#up to the class extending this module.
module AllSubclassAware
  attr_reader :subclasses
  def inherited(subclass)
    @subclasses << subclass
    superclass.__send__(:inherited, subclass)  #private
  end
end

class Foo
  extend DirectSubclassAware
  @subclasses = []
end

class Bar < Foo
  @subclasses = []
end

class Baz < Bar
end

class DirectSubclassAwareTest < Test::Unit::TestCase
  def test_direct_subclass_aware
    assert_equal([Bar], Foo.subclasses)
    assert_equal([Baz], Bar.subclasses)
  end
end

class Alpha
  extend AllSubclassAware
  @subclasses = []
end

class Beta < Alpha
  @subclasses = []
end

class Gamma < Beta
  @subclasses = []
end

class AllSubclassAwareTest < Test::Unit::TestCase
  def test_all_subclass_aware
    assert_equal([Beta, Gamma], Alpha.subclasses)
    assert_equal([Gamma], Beta.subclasses)
    assert_equal([], Gamma.subclasses)
  end
end