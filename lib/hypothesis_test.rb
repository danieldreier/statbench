# I am going to make one thing really clear up front about mean hypothesis tests:
# A FASTER CONFIGURATION MEANS A *LOWER* MEAN RESPONSE TIME. We are testing whether
# the new configuration is faster than the old one:
# H0: mu1 < mu2
# H1: mu1 >= mu2
# In other words, this is a right-tailed test for mean.

require 'statsample'
require_relative 'test_statistic'
require_relative 'data_analyst'
require_relative '../spec/data'

module HypothesisTest
  include Statsample
  include TestStatisticHelper

  def get_variables(hash)
    hash.each do |key,value|
      name = '@' + key
      instance_variable_set(name,value)
    end
  end

  def mean_hypothesis_test_left(hash=@hash,significance=0.05)
    get_variables(hash)
    t_star = (@mean2 - @mean1).quo(Math.sqrt(@var1 / (@nu1 + 1) + @var2/ (@nu2 + 2)))
    t_critical = TestStatisticHelper::initialize_with(:distribution       => :t,
                                                      :p                  => significance,
                                                      :degrees_of_freedom => @nu1 + @nu2)
    true if t_star <= t_critical
  end

  alias_method :slower?, :mean_hypothesis_test_left

  # Right-tailed test
  def mean_hypothesis_test_right(hash=@hash,significance=0.05)
    get_variables(hash)
    t_star = (@mean1 - @mean2).quo(Math.sqrt(@var1 / (@nu1 + 1) + @var2 / (@nu2 + 1)))
    t_critical = TestStatisticHelper::initialize_with(:distribution       => :t,
                                                      :p                  => 1 - significance,
                                                      :degrees_of_freedom => @nu1 + @nu2)
    true if t_star >= t_critical
  end

  alias_method :faster?, :mean_hypothesis_test_right

  # If this test is true, there's been an improvement in variability
  def variance_hypothesis_test_left(hash=@hash,significance=0.05)
    get_variables(hash)
    f_star       = @var1.quo(@var2)
    f_critical   = TestStatisticHelper::initialize_with(  :distribution         => :f,
                                                          :p                    => significance,
                                                          :tail                 => 'left',
                                                          :degrees_of_freedom_1 => @nu1,
                                                          :degrees_of_freedom_2 => @nu2 )
    puts "@var1  = #{@var1}"
    puts "@var2  = #{@var2}"
    puts "f_crit = #{f_critical}"
    puts "f_star = #{f_star}"
    true if f_star < f_critical
  end

  alias_method :more_variable?, :variance_hypothesis_test_left

  def variance_hypothesis_test_right(hash=@hash,significance=0.05)
    get_variables(hash)
    f_star     = @var1.quo(@var2)
    f_critical =TestStatisticHelper::initialize_with( :distribution         => :f,
                                                      :p                    => significance,
                                                      :tail                 => 'right',
                                                      :degrees_of_freedom_1 => @nu1,
                                                      :degrees_of_freedom_2 => @nu2 )
    true if f_star > f_critical
  end

  alias_method :more_consistent?, :variance_hypothesis_test_right
end

include HypothesisTest # I have no idea why this is required for it not to throw errors