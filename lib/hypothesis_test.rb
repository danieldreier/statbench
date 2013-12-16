require 'statsample'
require_relative 'test_statistic'
require_relative '../spec/data'

module HypothesisTest
  include Statsample
  include TestStatisticHelper

  def equal_response_time?(hash=@hash,significance=0.05)
    process_args(hash,significance)
    true unless mean_hypothesis_test(@hash)
  end

  def equal_variability?(hash=@hash,significance=0.05)
    process_args(hash,significance)
    true unless variance_hypothesis_test(@hash)
  end

  def get_variables(hash)
    @alpha ||= 0.05
    hash.each do |key,value|
      name = '@' + key
      instance_variable_set(name,value)
    end
  end

  def mean_hypothesis_test(hash)
    get_variables(hash)
    t_star = (@mean1 - @mean2).quo(Math.sqrt(@var1 / (@nu1 + 1) + @var2 / (@nu2 + 1)))
    t_critical = TestStatisticHelper::initialize_with(:distribution=>:t,
                                                      :p=>@alpha / 2,
                                                      :degrees_of_freedom=>@nu1 + @nu2)
    true if t_star.abs >= t_critical.abs
  end

  def mean_test_results(hash=@hash,significance=0.05)
    { :equal_mean? => equal_response_time?(hash,significance), :significance => @alpha }
  end

  def process_args(hash,significance)
    if hash.instance_of? Float 
      @alpha = hash
      @hash  = self.hash  # self is DataAnalyst
    elsif hash.instance_of?( Hash) && significance.instance_of?( Float)
      @hash  = hash 
      @alpha = significance || 0.05
    else
      raise(ArgumentError,'Invalid arguments')
    end
  end

  def variance_hypothesis_test(hash)
    get_variables(hash)
    f_star = @var1.quo(@var2)
    f_critical_1 = TestStatisticHelper::initialize_with(:distribution        =>:f,
                                                        :p                   =>@alpha / 2,
                                                        :tail                =>'right',
                                                        :degrees_of_freedom_1=>@nu1,
                                                        :degrees_of_freedom_2=>@nu2)
    f_critical_2 = TestStatisticHelper::initialize_with(:distribution        =>:f,
                                                        :p                   =>@alpha / 2,
                                                        :tail                =>'left',
                                                        :degrees_of_freedom_1=>@nu1,
                                                        :degrees_of_freedom_2=>@nu2)
    true if f_star > f_critical_1 || f_star < f_critical_2
  end

  def variance_test_results(hash=@hash,significance=0.05)
    { :equal_variance? => equal_variability?(hash,significance), :significance => @alpha }
  end
end

include HypothesisTest # I have no idea why this is required for it not to throw errors