require 'distribution'
require 'delegate'
require_relative 'test_statistic_helper.rb'

class TestStatistic < DelegateClass(Float)
  include TestStatisticHelper
  attr_reader :attributes
  attr_reader :value 
  attr_reader :distribution
  attr_reader :p
  attr_reader :nu
  attr_reader :nu1
  attr_reader :nu2
  attr_reader :tail

  alias_method :alpha, :p   
  alias_method :p_value, :p
  alias_method :significance_level, :p
  alias_method :degrees_of_freedom, :nu 
  alias_method :degrees_of_freedom_1, :nu1
  alias_method :degrees_of_freedom_2, :nu2

  def initialize(value)
    @value = __setobj__(value)
  end

  def abs
    @value.abs
  end

  def add_attributes(hash)
    @attributes = hash

    # These attributes are valid for all distributions
    @attributes[:value] ||= @value
    @p = @attributes[:p] ||= if @attributes[:alpha] then @attributes.delete(:alpha)
      elsif @attributes[:significance_level] then @attributes.delete(:significance_level); end
    @distribution = @attributes[:distribution]

    # These attributes are valid only for some distributions
    if @distribution == :t
      @nu = @attributes[:degrees_of_freedom]
    else
      @attributes.delete(:degrees_of_freedom) if @attributes.has_key?(:degrees_of_freedom)
      @attributes.delete(:nu) if @attributes.has_key?(:nu)
    end

    if @distribution == :f then @tail = @attributes[:tail]
    else @attributes.delete(:tail) if @attributes.has_key?(:tail); end

    if @distribution == :f
      @nu1 = @attributes[:degrees_of_freedom_1]
      @nu2 = @attributes[:degrees_of_freedom_2]
    else
      @attributes.delete(:degrees_of_freedom_1) if @attributes.has_key?(:degrees_of_freedom_1)
      @attributes.delete(:degrees_of_freedom_2) if @attributes.has_key?(:degrees_of_freedom_2)
    end
  end
end

