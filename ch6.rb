# Symbols - Eloquent Ruby ch 6
#
# Copyright 2013 Ian McNaney
#
# Some examples inspired by Chapter 6
#
# Symbols seem more or less like predefined constants, except you don't have to predefine them.
# They've also got a string value as well as a numeric value.
#
# Summary - use symbols as labels.  use strings for data that might need to be manipulated
require 'pp'

#They're singletons
a = :something
b = :something
puts "The symbols are the same object" if a.equal?(b)

#Unlike strings
a = 'something'
b = 'something'
puts a.equal?(b) ? "The strings are the same object" : "The strings are not the same object"

#They're also immutable, so :something will be the same symbol with the same numeric and string values
#until the program terminates.

#Interesting aside - Strings (mutable) as hash keys - what if you change the key string after using it to add to the hash?
#Hashes make copies of String keys to prevent this kind of trouble.  The immutability of symbols makes them more efficient for
#use as hash keys since copies don't need to be made.
key = 'the key'
my_hash = { key => 'value' }
key = 'changed key'
my_hash.each { |key, value| puts "#{key} => #{value}" }
puts key

#Creating a symbol from a String, and a String from a symbol
sym = 'foo'.to_sym
pp sym
str = :bar.to_s
pp str
