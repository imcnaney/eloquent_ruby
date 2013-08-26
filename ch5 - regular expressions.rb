# Regexes - Eloquent Ruby ch 5
#
# Copyright 2013 Ian McNaney
#
# Some examples inspired by Chapter 5
# Skipping most of it since I already know regexes
#
# Reminder - +, *, and {} are by default greedy and will match as much as possible.  To reverse this so
# that they match as little as possible add a ? after each, or use an inverted character class.

#Define a regex between two slashes
regex = /^[a-zA-Z]+$/

#Match with  =~
puts "Bacon" =~ regex ? "Bacon is a match" : "Bacon is not a match"
puts "4chan" =~ regex ? "4chan is a match" : "4chan is not a match"

#Where did it match?
puts "\nWhere did it match?"
regex = /([Bb]acon)|([Hh]am)/
result = "I'd like some bacon." =~ regex
puts result

#Note that it can match at index 0, which means there was a match at the beginning of the string.
puts "Bacon" =~ regex

#If there's no match it'll return nil (which also is conveniently false in boolean tests)
puts "\nnil if no match"
result = "I'd like some waffles." =~ regex
puts result.class.name

#Note that ^ and $ match the beginning and ending of a LINE.  To match the beginning and ending of the entire string
#use \A and \z
multi_line = "Line one
Line two
Line three"

regex = /^Line two$/
puts "\nWhere does Line two match?"
puts multi_line =~ regex

#This won' work because . won't match newlines
puts "\nAttempt one"
regex = /\ALine.*three\z/
puts multi_line =~ regex

#unless we tell it to by adding an m after the regex
puts "\nFixed"
regex = /\ALine.*three\z/m
puts multi_line =~ regex

#Greediness
text = "<one>content<two>"
puts "\nMatching #{text} with /<.*>/"
puts /<.*>/.match(text)  #Instead of just testing whether it matches, get a MatchData that'll tell us how.
                         #Oops, it matched the entire string
puts /<.*?>/.match(text) #that's better.
puts /<[^>]+>/.match(text)  #This is supposedly faster

#Capturing groups - use parentheses and refer to them in order of their left parenthesis with $n
if text =~ /((<.*?>).*(<.*?>))/
  puts "#{$1}, #{$2}, #{$3}"
end

