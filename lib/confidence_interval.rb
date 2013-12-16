require 'statsample'

module ConfidenceInterval
  include Statsample
  
  def mean_difference(data1=@data1,data2=@data2)
    data1.mean - data2.mean
  end

  def sdev_difference(data1=@data1,data2=@data2)
    data1.standard_deviation_sample - data2.standard_deviation_sample
  end
end