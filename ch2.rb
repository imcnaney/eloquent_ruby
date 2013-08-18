#Control structures, chapter 2 of Eloquent Ruby
#
# Copyright 2013 Ian McNaney
#
# Some examples inspired by Chapter 2

tall = false

#no surprise, and no output
if tall
  puts "Tall"
end

#legal, but frowned upon
if !tall
  puts "Short exclamation"
end

#legal, but frowned upon
if not tall
  puts "Short with not"
end

#preferred negation
unless tall
  puts "Short with unless"
end


############## LOOPING ##################
class Counter
  #a toy counter to use in the looping constructs
  attr_reader :value
  
  def initialize(value)
    #check this neat usage of if.  It doesn't seem that we can add an else and set @value directly
    #something like @value = value if value > 0 else @value = 0
    value = 0 if value < 0
    @value = value
  end
  
  def decrement
    @value -= 1 unless @value <= 0
  end  
  
  def empty?
    @value == 0
  end
  
  def has_counts?
    @value > 0
  end
end

#check the clever if usage
test = Counter.new(-10)
puts "Test value is #{test.value}"

foo = Counter.new(10)

#again, don't use the negation
while !foo.empty?
  foo.decrement
end
puts "decremented with negation - #{foo.value}"

#use until instead
foo = Counter.new(10)
until foo.empty?
  foo.decrement
end
puts "decremented with until - #{foo.value}"

#Now with more concise code
foo = Counter.new(10)
foo.decrement while foo.has_counts?
puts "Concise decrementing with while - #{foo.value}"

foo = Counter.new(10)
foo.decrement until foo.empty?
puts "Concise decrementing with until - #{foo.value}"

#Now for some for looping
fruits = [ "apples", "oranges", "pears", "kumquats" ]

for fruit in fruits
  puts fruit
end

#but do it this way instead, since the for loop just calls .each anyway
fruits.each { |fruit| puts fruit }
 
puts "#or this way"
fruits.each do |fruit|
  puts fruit
end  

####################### CASE ########################
#note that case uses === for its comparisons

#String equality
fruit = "lemon"
good_with_icecream = case fruit
  when "lemon" then false
  when "strawberry" then true
  when "blueberry" then true
  end

puts "#{fruit} is good with ice cream?  #{good_with_icecream}"

#class identity
foo = Counter.new(10)
is_counter = case foo
  when Counter then true
  else false
end

puts "foo is a Counter? #{is_counter}"

#even regex
match = case fruit
when /l.{3}n/ then puts "Could be lemon"
else puts "Not lemon"
end

###################### A Note on Boolean Logic ############
#The only "false" values are false and nil.  Comparing computed values directly to false or true is a bad idea.
#The book uses the example of defined?, which returns a string when something is defined.  It does not return the boolean
#true value, but since it's not false and not nil then the return value is considered to be true.  Also if the value
#is not defined then it returns nil, which is not literally the false boolean value but is still considered to be logically false.

#Also since nil and false are equivalent in terms of loop control, the following is dangerous:
#while a_thing = source.next_thing
#  do stuff
#end
# because source.next_thing could return a non-nil object, false, that will cause the loop to terminate prematurely.