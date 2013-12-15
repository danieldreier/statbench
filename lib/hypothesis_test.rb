require 'statsample'
require_relative 'test_statistic'
require_relative '../spec/data'

module HypothesisTest
  include Statsample
  include TestStatisticHelper

  def equal_response_time?(hash=@hash)
    true unless mean_hypothesis_test(hash)
  end

  def equal_variability?(hash=@hash)
    true unless variance_hypothesis_test(hash)
  end

  def mean_hypothesis_test(hash)
    n1     = hash['nu1'] + 1
    n2     = hash['nu2'] + 1
    df     = n1 + n2 - 2
    mean1  = hash['mean1']
    mean2  = hash['mean2']
    var1   = hash['var1']
    var2   = hash['var2']
    t_star = (mean1 - mean2).quo(Math.sqrt(var1 / n1 + var2 / n2))
    t_critical = TestStatisticHelper::initialize_with(:distribution=>:t,
                                                      :p=>0.025,
                                                      :degrees_of_freedom=>df)
    true if t_star.abs >= t_critical.abs
  end

  def variance_hypothesis_test(hash)
    df1 = hash['nu1']
    df2 = hash['nu2']
    var1 = hash['var1']
    var2 = hash['var2']
    alpha = 0.05
    f_star = var1.quo(var2)
    f_critical_1 = TestStatisticHelper::initialize_with(:distribution        =>:f,
                                                        :p                   =>alpha / 2,
                                                        :tail                =>'right',
                                                        :degrees_of_freedom_1=>df1,
                                                        :degrees_of_freedom_2=>df2)
    f_critical_2 = TestStatisticHelper::initialize_with(:distribution        =>:f,
                                                        :p                   =>alpha / 2,
                                                        :tail                =>'left',
                                                        :degrees_of_freedom_1=>df1,
                                                        :degrees_of_freedom_2=>df2)
    true if f_star > f_critical_1 || f_star < f_critical_2
  end
end

include HypothesisTest # I have no idea why this is required for it not to throw errors