# Duck typing - Chapter 8 of Eloquent Ruby
#
# Copyright 2013 Ian McNaney
#
# Some examples inspired by Chapter 8
#
# Objects' suitability for use in code blocks is not determined by their class hierarchy.  Either they do have
# the appropriate methods, or they don't and an exception will be thrown.

class Radio
  def turn_on
    puts "Next up on KSFO - Art Bell on Coast to Coast AM.  Stay tuned..."
  end
end

class Dime
  def turn_on
    puts "You reverse course almost immediately."
  end
end

[Radio.new, Dime.new].each { |obj| obj.turn_on }

#The result is that you don't get stuck with a type that *should* work with your code but doesn't because it's
#part of the wrong type hierarchy, forcing you to write an adapter that doesn't actually do anything other than
#hide the real underlying type.
  
#Use inheritance when you want to inherit actual functionality.  Otherwise just implement the appropriate methods
#and think of it as an implicit interface