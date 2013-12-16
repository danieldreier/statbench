require 'statsample'
require_relative 'test_statistic'

module ConfidenceInterval
  include Statsample
  include TestStatisticHelper
  
  # The get_variables method is also present in HypothesisTest.
  # When we refactor we will want to extract these to DRY it up.
  def get_variables(hash)
    hash.each do |key,value|
      name = '@' + key
      instance_variable_set(name,value)
    end
  end

  def mean_difference(hash=@hash)
    get_variables(hash)
    @alpha    = 0.05
    nu        = @nu1 + @nu2
    mse       = (@var1 + @var2).quo(2)
    std_error = Math.sqrt((2 * mse) / (nu + 2))
    t         = TestStatisticHelper::initialize_with(:distribution       => :t,
                                                     :alpha              => @alpha / 2,
                                                     :degrees_of_freedom => nu)
    lower = ((sample_diff = @mean1 - @mean2) - (margin = t.abs * std_error)).round(5)
    upper = (sample_diff +  margin).round(5)
    { :interval => [lower,upper], :confidence => 1 - @alpha }
  end

  def sdev_difference(hash=@hash)
    get_variables(hash)
    (@sdev1 ||= Math.sqrt(@var1)) - (@sdev2 ||= Math.sqrt(@var2))
  end
end