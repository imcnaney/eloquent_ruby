# Collections - hashes, arrays, and inject. chapter 3 of Eloquent Ruby
#
# Copyright 2013 Ian McNaney
#
# Some examples inspired by Chapter 3.
#
# Some examples are commented out because Eclipse doesn't like the syntax even though it's valid.

require 'pp'

################### Arrays ####################

#the obvious/tedious way to initialize one:
puts "\nArray ex 1"
obvious = ["one", "two", "three"]
puts obvious
  
#less tedious if they're all strings:
puts "\nArray ex 2"
better = %w{ these are all words in the array }
puts better

################## Hashes #####################

#the obvious/tedious way, with the advantage that the keys can be of any type
puts "\nHash ex 1"
obvious_hash = { "key1" => "val1", nil => 5, 5 => false }
puts obvious_hash

#If all the keys are symbols (which is common)  - Eclipse doesn't like it, but this syntax is valid as of 1.9
puts "\nHash ex 2"
#symbol_hash = { symbol_one: "Bob", symbol_two: 12 }
#puts symbol_hash

################# Variable numbers of args to methods ########################

#auto-create an array "splat" syntax
puts "\nSplat ex 1"
def auto_array( *args )
  args.each { |arg| puts arg }
end

auto_array( "foo", "bar", "baz", 1, 2, 3)
  
#There can be only one splat, but it can appear anywhere in the parameter list
puts "\nSplat ex 2"
#def splat_with_other_args(first, second, *args, last)
  #puts "First is #{first}"
  #puts "Second is #{second}"
  #args.each { |arg| puts "a splat arg: #{arg}" }
  #puts "Last is #{last}"
#end

#splat_with_other_args("first", "second", "foo", "bar", "baz", 5)

################## Iterating over hashes ####################
iterate_me = { :key_1 => "There", :key_2 => "is", :key_3 => "no", :key_4 => "spoon" }
  
#If the block has only one argument, it will be an array with the key/value pair as elements
puts "\nHash iteration ex 1"
iterate_me.each { |arg| puts "#{arg[0]}, #{arg[1]}" }
  
#If the block has two arguments they will be the key and the value
puts "\nHash iteration ex 2"
iterate_me.each { |key, value| puts "#{key}, #{value}" }
  
#Observe that the hash iterates "in order", or in the order that elements were added to it.  This is new behavior as of 1.9.
  
################# Handy collection methods #################
my_array = %w{ What is your name? What is your quest? What is your favorite color? }

#searching an array - the block gives the "match" condition
puts "\nSearching arrays example"
pp my_array
result = my_array.find_index { |element| element == 'name?' }
puts "'name?' appears at index #{result}"

#let's count the number of letters in each word
puts "Word size example using map"
result = my_array.map { |word| word.size }
pp result

#Let's count the total number of letters across all words
puts "Counting all characters using map and inject"
result = my_array.map { |word| word.size }.inject(0) { |total, size| total + size }
puts "The total number of characters is #{result}"

#Or we really can just do it with inject
puts "Counting all letters using inject"
result = my_array.inject(0) { |total, word| total + word.size }
puts "The total number of characters is #{result}"

#here's some voodoo
voodoo = (1..10).inject(:+)
puts "Voodoo: #{voodoo}"

#Note that we didn't have to modify total in our inject block.  The block returns the sum and inject passes it on automatically.

################ Modifying collections in-place vs creating a copy ############
#Methods with a ! are in-place if there are two options.  Some methods are obviously in-place and don't have a !, like pop.
my_array = %w{ Which way did he go George? Which way did he go? }

puts "In-place vs copy array modification"
pp my_array
reversed = my_array.reverse
pp reversed
my_array.reverse!
pp my_array

popped = my_array.pop
puts "Popped #{popped}"
pp my_array

#as an aside, check this out.  This makes me want to punch Java and its precious JAXB right in the ear.
puts "\nxml to hash example"
require 'xmlsimple'
parsed = XmlSimple.xml_in('ch3.xml')
parsed['book'].each { |book| pp book }
  
  
############## Don't forget about sets ################
#duplicates are not allowed.  appears to be unordered
puts "\nSet examples"
my_set = Set.new
my_set << "foo" << "bar" << "baz" << "foo"
pp my_set
another_set = Set.new(my_array)
pp another_set

#how many words in the set contain non-word characters?
result = another_set.inject(0) { |total, word| /\W/ =~ word ? total + 1 : total }
puts "There are #{result} words with non-word characters."