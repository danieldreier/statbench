require 'statsample'

module HypothesisTest
  include Statsample

  def equal_response_time?(data1=@dataset_1,data2=@dataset_2)
    data1.mean == data2.mean
  end

  def equal_variability?(data1=@dataset_1,data2=@dataset_2)
    data1.standard_deviation_sample == data2.standard_deviation_sample
  end
end
