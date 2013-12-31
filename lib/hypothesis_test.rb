# I am going to make one thing really clear up front about mean hypothesis tests:
# A FASTER CONFIGURATION MEANS A *LOWER* MEAN RESPONSE TIME. We are testing whether
# the new configuration is faster than the old one:
# H0: mu1 < mu2
# H1: mu1 >= mu2
# In other words, this is a right-tailed test for mean.

require 'statsample'
require_relative 'test_statistic'
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

  def mean_test_results(hash=@hash,significance=0.05)
    summary = if faster?(hash,significance) then "configuration 2 is faster";
    elsif mean_hypothesis_test_left(hash,significance) then "configuration 2 is slower";
    else "mean response time hasn't changed" end
    { :summary => summary, :confidence => 1 - significance }
  end

  def variance_hypothesis_test(hash,significance)
    get_variables(hash)
    f_star = @var1.quo(@var2)
    f_critical_1 = TestStatisticHelper::initialize_with(:distribution        =>:f,
                                                        :p                   =>significance / 2,
                                                        :tail                =>'left',
                                                        :degrees_of_freedom_1=>@nu1,
                                                        :degrees_of_freedom_2=>@nu2)
    f_critical_2 = TestStatisticHelper::initialize_with(:distribution        =>:f,
                                                        :p                   =>significance / 2,
                                                        :tail                =>'right',
                                                        :degrees_of_freedom_1=>@nu1,
                                                        :degrees_of_freedom_2=>@nu2)
    true if ((f_star < f_critical_1) || (f_star > f_critical_2))
  end

  alias_method :more_consistent?, :variance_hypothesis_test

  def variance_test_results(hash=@hash,significance=0.05)
    summary = if more_consistent?(hash,significance) then "configuration 2 is more consistent";
    else "variability in response time hasn't changed"; end
    { :summary => summary, :confidence => 1 - significance }
  end
end

include HypothesisTest # I have no idea why this is required for it not to throw errors