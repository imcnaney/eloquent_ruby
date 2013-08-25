# Modifying subclasses - Chapter 26 of Eloquent Ruby
#
# Copyright 2013 Ian McNaney
#
# Some examples inspired by Chapter 26
#
# Summary:  define_method works on subclasses as well - it defines the new method on the subclass
# since that's what self is when the method gets invoked on a subclass.
#
# Because self is whatever class the method was invoked on, all the tricks for a class modifying itself
# also work on subclasses.  For example, changing method visibility and redefining methods can also be done,
# as well as include, extend, remove_method
require 'test/unit'

class Salad
  def self.add_method(name, &block)
    define_method(name.to_sym, &block)
  end
end

class FruitSalad < Salad
end

class CaesarSalad < Salad
end

class DefineMethodTest < Test::Unit::TestCase
  def test_define_method_on_subclasses
    fruit = FruitSalad.new
    caesar = CaesarSalad.new
    
    FruitSalad.add_method(:cracked_pepper?) { "Eww!" }
    CaesarSalad.add_method(:cracked_pepper?) { "Yes please." }
      
    assert_equal("Eww!", fruit.cracked_pepper?)
    assert_equal("Yes please.", caesar.cracked_pepper?)    
  end
end

#This is also how attr_reader and attr_writer work
#in reality you'd probably want to be careful not to accidentally override methods like to_s
#or send
class AttrExample
  def self.already_exists_check(symbol)
    raise "Method already exists: #{symbol}" if instance_methods.include?(symbol)
  end
  def self.my_attr_reader(name)
    already_exists_check(name.to_sym)
    var_name = "@#{name}"
    define_method(name.to_sym) { instance_variable_get(var_name.to_sym) }
  end
  def self.my_attr_writer(name)
    method_name = "#{name}="
    already_exists_check(method_name.to_sym)
    var_name = "@#{name}"
    define_method(method_name.to_sym) { |x| instance_variable_set(var_name.to_sym, x) }
  end
  
  my_attr_reader :foo
  my_attr_writer :foo
end

class AttrExampleTest < Test::Unit::TestCase
  def test_my_attr_reader
    ex = AttrExample.new
    ex.foo = "foo"
    assert_equal("foo", ex.foo)
  end
  
  def test_invoking_externally
    AttrExample.my_attr_reader(:external)
    AttrExample.my_attr_writer(:external)
    ex = AttrExample.new
    ex.external = "External"
    assert_equal("External", ex.external)
  end
  
  def test_redefining_existing_method
    AttrExample.my_attr_reader(:duplicate)
    error = assert_raise(RuntimeError) { AttrExample.my_attr_reader(:duplicate) }
    assert_match(/Method already exists/, error.message)
    error = assert_raise(RuntimeError) { AttrExample.my_attr_reader(:send) }
    assert_match(/Method already exists/, error.message)
  end
  
  #This is interesting - be careful not to use existing method names for attr_reader, attr_writer, or attr_accessor
  #because it will let you do that.
  def test_existing_attr_reader
    AttrExample.send(:attr_reader, :to_s)
    AttrExample.send(:attr_writer, :to_s)
    ex = AttrExample.new
    ex.to_s = "abc"
    assert_equal("abc", ex.to_s)
  end
end