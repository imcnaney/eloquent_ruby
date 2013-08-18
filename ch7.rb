# Objects - chapter 7 of Eloquent Ruby
#
# Copyright 2013 Ian McNaney
#
# Some examples inspired by Chapter 7
#
# Summary - (almost) everything is an object, even nil and 42.
# Be careful not to accidentally override methods inherited from Object or confusion will ensue.
require 'pp'

# "self" behaves the same way "this" does in Java
class Trivial
  attr_reader :count
  
  def initialize()
    @count = 0
  end
  
  def speak
    @count += 1
    puts "I am #{self} of Borg"
    #self.@count doesn't appear to work, which is fine because that's silly anyway
    puts "I have spoken #{self.count} time#{"s" if @count > 1}."
  end
end

instance = Trivial.new
instance.speak
instance.speak

#Since we didn't explicitly specify a parent class it by default extends Object
puts "Instance is an Object" if instance.is_a? Object

#To specify a parent class
class LessTrivial < Trivial
  attr_reader :greeting
  
  def initialize(greeting)
    super()
    @greeting = greeting
  end
  
  def speak
    @count += 1
    puts @greeting
    puts "I have spoken #{@count} time#{"s" if @count > 1}."
  end
end

another = LessTrivial.new("Howdy there!")
another.speak
puts "count is: #{another.count}, greeting is: '#{another.greeting}'"

################# Everything is an object #############
puts "\nAll objects..."
puts nil.class.name
puts 42.class.name
puts false.class.name
puts /\w+/.class.name
puts :foo.class.name
puts "\nEven classes are objects"
puts true.class.class.name

################ All Objects have some reflection capabilities ###########
puts "\nReflection"
pp another.instance_variables
pp another.public_methods

################ Public, protected, and private ###########
# methods are public by default.  Everything after an access modifier gets that access level

class Example
  def i_am_public
    puts "Public method"
  end
  
  private
  def i_am_private
    puts "Private method"
  end
end

ex = Example.new
ex.i_am_public
begin
  puts "Directly calling a private method"
  ex.i_am_private      #won't work because it's private
rescue NoMethodError => err
  puts "  Exception caught: " + err.to_s
end

#Private really means that the method "can't" be called with an explicit object reference
class AnotherExample
  def to_be_private
    puts "I was made private"
  end
  
  def call_private_method_with_explicit_self_reference
    self.to_be_private  #you'd think this would work, but it doesn't.
  end
  
  def call_private_method_with_implicit_self_reference
    to_be_private  #This does work
  end
  
  private :to_be_private  #another way of declaring that it's private
end

ex = AnotherExample.new
begin
  puts "\nCalling a private method with an explicit self reference"
  ex.call_private_method_with_explicit_self_reference
rescue NoMethodError => err
  puts "  Exception caught " + err.to_s
end    
ex.call_private_method_with_implicit_self_reference()

#This means that subclasses can call private superclass methods, since they don't need an explicit object reference
puts "\nCalling a private method in the superclass"
class SubClassPrivate < AnotherExample
  def call_private_method_in_superclass
    to_be_private
  end
end

ex = SubClassPrivate.new
ex.call_private_method_in_superclass

#Protected means that any instance of the class (or any instance of a subclass) can call the method on any other instance (or instance of a subclass)

#These visibility levels are easy to bypass if you're really sure you want to
puts "\nCalling a private method anyway, using send"
bypass = AnotherExample.new
bypass.send(:to_be_private)
