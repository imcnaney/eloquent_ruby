class Sandbox  #camelcase
  HELLO_TEXT = "hello"  #constants can be caps with underscores or camelcase
  def say_hello  #method names should be snake case
    puts HELLO_TEXT
  end
end

foo = Sandbox.new
foo.say_hello

#preferred to omit the do/end in the  case of a one-line block
10.times { |n| puts "The number is #{n}" }  #prints one per line
10.times { |n| print "The number is #{n}" }  #prints all together
  
#For multiline blocks use do/end
10.times do |n|
  puts "The number is #{n}"
  puts "Twice the number is #{n*2}"
end

#This also works but is frowned upon for multiline blocks.  use do/end instead
10.times { |n|
  puts "Three times the number is #{n*3}"
  puts "Four times the number is #{n*4}"
}

puts foo.instance_of?(Sandbox)

pi = Float("3.1415")  #built in rule-breaker.  This is in fact a method, but it can be used like a class
puts pi