require 'statsample'
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

  def initialize(value)
    @value = __setobj__(value)
  end

  def add_attributes(hash)
    @attributes = hash

    # These attributes are valid for all distributions
    @attributes[:value] ||= @value
    @attributes[:p] = @attributes.delete(:alpha) if @attributes[:alpha] # Standardize nomenclature

    @p = @attributes[:p]
    @distribution = @attributes[:distribution]

    # These attributes are valid only for some distributions
    if @distribution == :z || @distribution == :chi2
      @nu = @attributes[:degrees_of_freedom]
    else
      @attributes.delete(:degrees_of_freedom) if @attributes.has_key?(:degrees_of_freedom)
    end

    if @distribution == :chi2 || @distribution == :f
      @tail = @attributes[:tail]
    else
      @attributes.delete(:tail) if @attributes.has_key?(:tail)
    end

    if @distribution == :f
      @nu1 = @attributes[:degrees_of_freedom_1]
      @nu2 = @attributes[:degrees_of_freedom_2]
    else
      @attributes.delete(:degrees_of_freedom_1) if @attributes.has_key?(:degrees_of_freedom_1)
      @attributes.delete(:degrees_of_freedom_2) if @attributes.has_key?(:degrees_of_freedom_2)
    end
  end

  def degrees_of_freedom
    if @distribution == :f || @distribution == :z then nil; else self.nu(); end
  end

  def degrees_of_freedom_1
    raise('Error: Attribute valid only for F distribution') unless self.distribution == :f
    self.nu1()
  end

  def degrees_of_freedom_2
    raise('Error: Attribute valid only for F distribution') unless self.distribution == :f
    self.nu2()
  end
end

