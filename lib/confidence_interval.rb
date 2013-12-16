require 'statsample'
require_relative 'test_statistic'

module ConfidenceInterval
  include Statsample
  include TestStatisticHelper
  
  # The #process_args method is also present in HypothesisTest.
  # When we refactor we will want to extract these to DRY it up.
  def process_args(hash,confidence_level=nil)
    if hash.instance_of? Float 
      @alpha = 1 - hash
      @hash = self.hash
    elsif hash.instance_of? Hash
      @hash = hash
      @alpha = if confidence_level then 1 - confidence_level; else 0.05; end
    else
      raise(ArgumentError,'Invalid arguments')
    end
    get_variables(@hash)
  end

  # The #get_variables method is also present in HypothesisTest.
  # When we refactor we will want to extract these to DRY it up.
  def get_variables(hash)
    hash.each do |key,value|
      name = '@' + key
      instance_variable_set(name,value)
    end
  end

  def mean_interval(statistic,point_estimate)
    std_error = standard_error
    [(point_estimate - statistic.abs*std_error).round(5), 
     (point_estimate + statistic.abs * std_error).round(5) ]
  end

  def mean_difference(hash=@hash,confidence=0.95)
    process_args(hash)
    t = TestStatisticHelper::initialize_with(:distribution       => :t,
                                             :alpha              => @alpha / 2,
                                             :degrees_of_freedom => @nu1 + @nu2)
    { :interval => mean_interval(t,@mean1 - @mean2), :confidence => 1 - @alpha }
  end

  def standard_error
    Math.sqrt((@var1 + @var2).quo(@nu1 + @nu2 + 2))
  end

  def sdev_difference(hash=@hash,confidence=0.95)
    process_args(hash,confidence)
    f1 = TestStatisticHelper::initialize_with(:distribution         => :f, 
                                              :degrees_of_freedom_1 => @nu1,
                                              :degrees_of_freedom_2 => @nu2,
                                              :tail                 => 'right',
                                              :alpha                => @alpha / 2 )
    f2 = TestStatisticHelper::initialize_with(:distribution         => :f, 
                                              :degrees_of_freedom_1 => @nu1,
                                              :degrees_of_freedom_2 => @nu2,
                                              :tail                 => 'left',
                                              :alpha                => @alpha / 2)
    point_estimate = @var1 / @var2
    interval = [ Math.sqrt(point_estimate / f1).round(5), Math.sqrt(point_estimate / f2).round(5) ]
    { :interval => interval, :confidence => 1 - @alpha }
  end
end