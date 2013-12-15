require 'statsample'
require_relative 'test_statistic'
require_relative '../spec/data'

module HypothesisTest
  include Statsample
  include TestStatisticHelper

  def equal_response_time?(data1=@data1,data2=@data2)
    true unless mean_hypothesis_test(data1,data2)
  end

  def equal_variability?(data1=@data1,data2=@data2)
    true unless variance_hypothesis_test(data1,data2)
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

  def variance_hypothesis_test(data1,data2)
    df1 = data1.size - 1
    df2 = data2.size - 1
    var1 = (data1.standard_deviation_sample) ** 2
    var2 = (data2.standard_deviation_sample) ** 2
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

include HypothesisTest
include Statsample
data1 = DATASET_1.to_scale
data2 = DATASET_2.to_scale
p "Difference = #{data1.mean - data2.mean}"
p "Data Set 1 Standard Deviation = #{data1.standard_deviation_sample}"
p "Data Set 2 Standard Deviation = #{data2.standard_deviation_sample}"