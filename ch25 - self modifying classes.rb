# Self modifying classes - Chapter 25 of Eloquent Ruby
#
# Copyright 2013 Ian McNaney
#
# Some examples inspired by Chapter 25
#
# Summary: Class definitions are actually executed from top to bottom in the context of "self", 
# so you can include logic to conditionally define methods, as well as methods to redefine methods.
#
# Also included - some methods to redefine other methods on the class itself, on the instance with
# lambdas, and on the singleton class.  They're not the most direct way of accomplishing this exact
# functionality but they do demonstrate the relevant concepts with a minimum of additional complexity.
require 'test/unit'

class Goose
  puts "Hello, I'm a goose class."
  
  attr_reader :speech_count
  
  def initialize()
    @speech_count = 0
  end
  
  def speak()
    @speech_count += 1
    "Honk"
  end
  
  #a class method that redefines the speak method
  #This seems extraordinarily tedious
  def self.new_speak(mode)
    case mode
    when :honk
      def speak()
        @speech_count += 1
        "Honk"
      end
    when :not_a_duck
      def speak()
        @speech_count += 1
        "I am not a duck."
      end
    else
      def speak()
        @speech_count += 1
        "What?"
      end
    end
  end
  
  #Generate and store a lambda and redefine the speak method to call it
  #This has the same effect as creating a singleton method even though the mechanism
  #is slightly different
  def gen_speak(message)
    @speak_lambda = lambda do
      @speech_count += 1
      message
    end
    def speak()
      @speak_lambda.call
    end
  end
  
  #Note that this redefines the method for all instances
  def gen_speak_with_define_method(message)
    self.class.send(:define_method, :speak) do
      @speech_count += 1
      message
    end
  end
  
  #Directly create a singleton method.  This works as of 1.9
  def gen_speak_with_define_singleton_method(message)
    define_singleton_method(:speak) do
      @speech_count += 1
      message
    end
  end
  
  def gen_speak_with_a_block(&block)
    @speech_callback = block
    def speak()
      @speech_count += 1
      @speech_callback.call
    end
  end
  
  def gen_speak_with_block_and_def_singleton(&block)
    define_singleton_method(:speak, &block)
  end
  
  #I don't like having to manually insert @speak_count += 1 in the block.
  def new_speak_auto_count(&block)
    define_singleton_method(:speak, with_count(&block))
  end
  
  def with_count()
    lambda do
      @speech_count += 1
      yield
    end
  end
  
end

class GooseTest < Test::Unit::TestCase
  def setup
    #the class method redefinitions persist between tests, so explicitly reset it to "Honk"
    Goose.new_speak(:honk)
  end
  
  def test_speak
    assert_equal("Honk", Goose.new.speak)
  end
  
  def test_new_speak
    goose = Goose.new
    Goose.new_speak(:not_a_duck)
    assert_equal("I am not a duck.", goose.speak)
    Goose.new_speak(:jibberish)
    assert_equal("What?", goose.speak)
    Goose.new_speak(:honk)
    assert_equal("Honk", goose.speak)
  end
  
  def test_lambda
    goose = Goose.new
    goose.gen_speak("numero uno")
    assert_equal("numero uno", goose.speak)
    assert_equal(1, goose.speech_count)
    goose.speak
    assert_equal(2, goose.speech_count)
  end
  
  def test_define_method
    goose = Goose.new
    goose2 = Goose.new
    goose.gen_speak_with_define_method("Hello there!")
    assert_equal("Hello there!", goose.speak)
    assert_equal("Hello there!", goose2.speak)
    assert_equal(1, goose.speech_count)
    goose.speak
    assert_equal(2, goose.speech_count)
    assert_equal(1, goose2.speech_count)
  end
  
  def test_define_singleton_method
    goose = Goose.new
    goose2 = Goose.new
    goose.gen_speak_with_define_singleton_method("Singleton!")
    assert_equal("Singleton!", goose.speak)
    assert_equal(1, goose.speech_count)
    assert_equal("Singleton!", goose.speak)
    assert_equal(2, goose.speech_count)
    assert_equal("Honk", goose2.speak)
  end
  
  def test_block
    goose = Goose.new
    goose.gen_speak_with_a_block { "Hello.  Speech count is: #{goose.speech_count}" }
    assert_equal("Hello.  Speech count is: 1", goose.speak)
    assert_equal("Hello.  Speech count is: 2", goose.speak)
    assert_equal(2, goose.speech_count)
  end
  
  #Note that we can refer to instance variables within the block
  def test_block_and_define_singleton
    goose = Goose.new
    goose2 = Goose.new
    message = "Welcome to the goose chase."
    goose.gen_speak_with_block_and_def_singleton { @speech_count += 1; message }
    assert_equal(message, goose.speak)
    assert_equal(1, goose.speech_count)
    goose.speak
    assert_equal(2, goose.speech_count)
    assert_equal("Honk", goose2.speak)
    assert_equal(1, goose2.speech_count)
  end
  
  def test_block_and_auto_count
    goose = Goose.new
    goose.new_speak_auto_count { "Howdy" }
    assert_equal("Howdy", goose.speak)
    assert_equal(1, goose.speech_count())
  end
end