require 'statsample'
require_relative 'data_analyst'
require_relative 'test_statistic'

# The mean confidence interval gives an interval estimate of 
# the difference in response times between two configurations. The confidence level indicates the percent
# probability that the real difference is in the interval. (You can never be 100% sure.) For example, if 
# you have an interval of (-1.33, 3.74) with confidence level 0.95, that means we're 95% sure the new 
# server configuration is not more than 1.33 seconds SLOWER than the old one, and also not more than 3.74
# seconds faster.

module ConfidenceInterval
  include Statsample
  include TestStatisticHelper

  # The #get_variables method is also present in HypothesisTest.
  # When we refactor we will want to extract these to DRY it up.
  def get_variables(hash)
    hash.each do |key,value|
      name = '@' + key
      instance_variable_set(name,value)
    end
  end

  def mean_interval(statistic,point_estimate)
    [(point_estimate - statistic.abs * standard_error).round(5), 
     (point_estimate + statistic.abs * standard_error).round(5) ]
  end

  def mean_difference(hash=@hash,confidence=0.95)
    get_variables(hash)
    t = TestStatisticHelper::initialize_with(:distribution       => :t,
                                             :alpha              => (1 - confidence) / 2,
                                             :degrees_of_freedom => @nu1 + @nu2)
    { :interval => mean_interval(t,@mean1 - @mean2), :confidence => confidence }
  end

  def standard_error
    Math.sqrt((@var1 + @var2).quo(@nu1 + @nu2 + 2))
  end

  def sdev_difference(hash=@hash,confidence=0.95)
    get_variables(hash)
    f1 = TestStatisticHelper::initialize_with(:distribution         => :f, 
                                              :degrees_of_freedom_1 => @nu1,
                                              :degrees_of_freedom_2 => @nu2,
                                              :tail                 => 'right',
                                              :alpha                => (1 - confidence) / 2 )
    f2 = TestStatisticHelper::initialize_with(:distribution         => :f, 
                                              :degrees_of_freedom_1 => @nu1,
                                              :degrees_of_freedom_2 => @nu2,
                                              :tail                 => 'left',
                                              :alpha                => (1 - confidence) / 2)
    point_estimate = @var1 / @var2
    interval = [ Math.sqrt(point_estimate / f1).round(5), Math.sqrt(point_estimate / f2).round(5) ]
    { :interval => interval, :confidence => confidence }
  end
end