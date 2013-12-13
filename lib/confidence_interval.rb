require 'statsample'

module ConfidenceInterval
  include Statsample
  
  def mean_difference(data1=@dataset_1,data2=@dataset_2)
    data1.mean - data2.mean
  end
end