# Blocks for iteration - Chapter 17 of Eloquent Ruby
#
# Copyright 2013 Ian McNaney
#
# Some examples inspired by Chapter 17
#
# Summary: We can tell if a block was provided by calling block_given?
#
require "test/unit"

class Node
  attr_accessor :next, :value
  def initialize(value)
    @value = value
    @next = nil
  end
end

class LinkedList
  attr_accessor :size
  
  def initialize()
    @size = 0
  end
  
  def add_at_head(value)
    node = Node.new(value)
    node.next = @head
    @head = node
    @size += 1
  end
  
  def remove_head()
    return nil if @head == nil
    value = @head.value
    @head = @head.next
    @size -= 1
    value
  end
  
  def contains?(value)
    current = @head
    while current
      return current.value if current.value == value
      current = current.next
    end
  end
  
  def each
    return unless block_given?
    current = @head
    while current
      yield(current.value)
      current = current.next
    end
  end
  
  def <<(value)
    add_at_head(value)
    self
  end
end

class LinkedListTest < Test::Unit::TestCase
  def test_insert
    list = LinkedList.new
    list.add_at_head(3)
    assert_equal(1, list.size)
    
    list << 5
    assert_equal(2, list.size)
  end
  
  def test_remove_head
    list = LinkedList.new
    list.add_at_head(3)
    result = list.remove_head()
    assert_equal(3, result)
  end
  
  def test_each
    list = LinkedList.new
    list << 3 << 5
    arr = []
    list.each {|value| arr << value}
    assert_equal([5, 3], arr)
  end
end

#We can iterate over things that don't actually exist as a collection
#as long as they can be generated in order
class Powers
  def initialize(number, limit)
    @number = number
    @limit = limit
  end
  
  def each()
    return unless block_given?
    power = 1
    while power <= @limit
      yield(@number**power)
      power += 1
    end
  end
end

class TestPowers < Test::Unit::TestCase
  def test_powers
    arr = []
    powers = Powers.new(2, 4)
    powers.each() {|result| arr << result}
    assert_equal([2, 4, 8, 16], arr)
  end
end

#By including the Enumerable mixin we get a bunch of functionality for free
class Powers
  include Enumerable
end

class PowersEnumerableTest < Test::Unit::TestCase
  def test_powers_enumerable
    powers = Powers.new(2, 4)
    result = powers.to_a
    assert_equal([2, 4, 8, 16], result)
    
    result = []
    powers.each_cons(2) {|arr| result << arr}
    assert_equal([[2,4],[4,8],[8,16]], result)
  end
end

#If we don't want to use the default each() method for iterating we can create an Enumerator
class Words
  include Enumerable
  
  def initialize(string)
    @words = string.split(/\W/).to_a
  end
  
  def each
    @words.each {|word| yield(word)}
  end
  
  def each_letter
    @words.each do |word|
      word.each_char {|letter| yield(letter)}
    end
  end
end

class TestWords < Test::Unit::TestCase
  def test_creation
    words = Words.new("abc def")
    assert_equal(["abc", "def"], words.to_a)
  end
  
  def test_enumerator
    words = Words.new("abc def")
    enum = Enumerator.new(words, :each_letter)
    result = enum.each.to_a
    assert_equal(["a", "b", "c", "d", "e", "f"], result)
  end
end

#Beware of trusting blocks.  If they raise an exception or return/break
#then the method that yielded will immediately terminate.  If there's any
#cleanup to be done then use begin/ensure
class DoCleanup
  attr_reader :clean
  
  def initialize()
    @clean = true
  end
  
  def do_stuff
    @clean = false
    begin
      yield
    ensure
      @clean = true
    end
  end
  
  def do_stuff_dangerously
    @clean = false
    yield
    @clean = true
  end
end

class CleanupTest < Test::Unit::TestCase
  def test_cleanup
    foo = DoCleanup.new
    foo.do_stuff { break }
    assert(foo.clean)
  end
  
  def test_broken_cleanup
    foo = DoCleanup.new
    foo.do_stuff_dangerously { break }
    assert(!foo.clean)
  end
end