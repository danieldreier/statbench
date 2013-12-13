require 'statsample'
require_relative 'test_statistic'
require_relative '../spec/data'

module HypothesisTest
  include Statsample
  include TestStatisticHelper

  def equal_response_time?(data1=@dataset_1,data2=@dataset_2)
    true unless mean_hypothesis_test(data1,data2)
  end

  def equal_variability?(data1=@dataset_1,data2=@dataset_2)
    data1.standard_deviation_sample == data2.standard_deviation_sample
  end

  def mean_hypothesis_test(data1,data2)
    df     = (n1 = data1.size) + (n2 = data2.size) - 1
    mean1  = data1.mean
    mean2  = data2.mean
    var1   = (data1.standard_deviation_sample) ** 2
    var2   = (data2.standard_deviation_sample) ** 2
    t_star = (mean1 - mean2).quo(Math.sqrt(var1 / n1 + var2 / n2))
    t_critical = TestStatisticHelper::initialize_with(:distribution=>:t,
                                                      :p=>0.025,
                                                      :degrees_of_freedom=>df)
    true if t_star.abs >= t_critical.abs
  end
end

include HypothesisTest
include Statsample
data1 = DATASET_1.to_scale
data2 = DATASET_2.to_scale
p "Difference = #{data1.mean - data2.mean}"
p "Data Set 1 Standard Deviation = #{data1.standard_deviation_sample}"
p "Data Set 2 Standard Deviation = #{data2.standard_deviation_sample}"