require 'statsample'
require_relative 'test_statistic'

module ConfidenceInterval
  include Statsample
  include TestStatisticHelper
  
  # The get_variables method is also present in HypothesisTest.
  # When we refactor we will want to extract these to DRY it up.
  def get_variables(hash)
    @alpha = 0.05
    hash.each do |key,value|
      name = '@' + key
      instance_variable_set(name,value)
    end
  end

  def interval(statistic,point_estimate,parameter)
    std_error = standard_error(parameter)
    [(point_estimate - statistic.abs*std_error).round(5), 
     (point_estimate + statistic.abs * std_error).round(5) ]
  end

  def mean_difference(hash=@hash)
    get_variables(hash)
    t         = TestStatisticHelper::initialize_with(:distribution       => :t,
                                                     :alpha              => @alpha / 2,
                                                     :degrees_of_freedom => @nu1 + @nu2)
    { :interval => interval(t,@mean1 - @mean2,:mean), :confidence => 1 - @alpha }
  end

  def standard_error(parameter)
    case parameter
    when :mean
      Math.sqrt((@var1 + @var2).quo(@nu1 + @nu2 + 2))
    when :variance
      p "pending"
    end
  end

  def sdev_difference(hash=@hash)
    get_variables(hash)
    (@sdev1 ||= Math.sqrt(@var1)) - (@sdev2 ||= Math.sqrt(@var2))
  end
end