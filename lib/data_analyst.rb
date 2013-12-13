require 'statsample'
require_relative 'hypothesis_test'
require_relative 'confidence_interval'

class DataAnalyst
  include Statsample
  include HypothesisTest
  include ConfidenceInterval

  def initialize(data1,data2)
    @dataset_1 = if data1.class == Vector then data1; else data1.to_scale; end
    @dataset_2 = if data2.class == Vector then data2; else data2.to_scale; end
  end

  def sdev_difference
    @dataset_1.standard_deviation_sample - @dataset_2.standard_deviation_sample
  end
end

#   def set_variables(array)
#     array.each do |data|
#       variable_name = "@dataset_" + (i = (array.find_index(data) + 1).to_s) 
#       size_variable = "@n" + i
#       data          = data.to_scale if data.instance_of? Array 
#       instance_variable_set(variable_name,data)
#       instance_variable_set(size_variable,data.size)
#     end
#   end