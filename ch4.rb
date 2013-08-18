# Strings - Eloquent Ruby ch 4
#
# Copyright 2013 Ian McNaney
#
# Some examples inspired by Chapter 4
require 'pp'

#########################################################
################## STRINGS ARE MUTABLE ##################
#########################################################

############## Creating Strings ##############

string_literal = 'Single quotes only understand escaped single quotes \' and escaped backslashes \\ .'
puts string_literal

double_quoted = "Double quotes allow for a wider set of escaped characters like tabs: \t and newlines \n.  Also allow arbitrary evaluation and substitution: 3*3 = #{3*3}"
puts double_quoted

spans_lines = "Any string can span lines 
like this"
puts spans_lines

spans_lines_suppress_newline = "To suppress the embedded newline include a backslash \
at the end of the line"
puts spans_lines_suppress_newline

percent_quoted = %q^This string can use both single quotes ' and double quotes ", but otherwise behaves like a double quoted string.  #{3*3}^
puts percent_quoted

percent_quoted_double = %Q{This can also use both quote types, but the capital Q behaves like a double quoted string.  #{Time.now}}
puts percent_quoted_double

here_doc = <<EOF
Yesterday, upon the stair,
I met a man who wasn’t there
He wasn’t there again today
I wish, I wish he’d go away...
EOF
puts here_doc

############### Some handy String methods ##################
puts "\nSome string manipulation examples"
whitespace = "\tI have whitespace on both ends\t\t"
puts whitespace + '.'

puts whitespace.lstrip + '.'
puts whitespace.rstrip + '.'
puts whitespace.strip + '.'

#note that + concatenates the strings by making a third, leaving the originals unmodified.
#Using << instead will append to the left string in-place.
puts "\nSome concatenation examples"
empty = ""
not_empty = empty << "Thing One " << "Thing Two"
puts "Empty: #{empty}"
puts "Not empty: #{not_empty}"

#Chomp gives a COPY of the string with one newline character (technically $/) removed from the end.
#for example when reading from a file and each line ends with a newline
puts "\nChomp"
puts "Bring me four fried chickens and a coke.\n".chomp + "  You want chicken wings or chicken legs?"
#It leaves other whitespace alone
puts "Four fried chickens, and a coke.  ".chomp + "And some dry white toast please."
  
#Chop is not so picky.  It removes the last character every time.
puts "\nChop"
puts "Y'all want anything to drink with that?  No ma'am.  A coke.".chop

#Changing cases
mixed = "AbCdEfG"
puts mixed
puts mixed.upcase
puts mixed.downcase
puts mixed.swapcase

#Substitution, regular and greedy
puts "\nSubstitution"
original = "Bring me four fried chickens and a coke.\n\tYou want chicken wings or chicken legs?\nFour fried chickens, and a coke."
puts original.sub("chicken", "elephant")

puts "\n"
puts original.gsub("chicken", "unicorn")

#Splitting
puts "\nSplitting"
record = "Jake Blues:Four fried chickens:A Coke"
#by default it uses runs of whitespace as the delimiter
result = record.split
pp result

#can specify a delimiter string
result = record.split(":")
pp result

#regexes work too
result = record.split(/f\w+/)
pp result

#Searching
puts "\nSearching"
puts original.index("chickens")
puts original.index(/f\w+/)

################ Strings as collections ################
str = 'Bacon'

puts "\nStrings as collections of characters"
str.each_char { |c| print "#{c} " }
  
puts "\nStrings as collections of bytes"
str.each_byte { |b| print "#{b} " }
  
str = "Bacon\nEggs\nSpam\nSpam\nSpam"
puts "\nStrings as collections of lines"
str.each_line { |line| print "#{line.chomp} " }
puts "\n"

############### Array indexing strings #################
str = "Bacon"
puts "\nArray indexing strings"
str[2..-1].each_char { |c| puts c }
