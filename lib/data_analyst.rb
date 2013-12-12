require 'statsample'
require_relative '../spec/data'

class DataAnalyst
  include Statsample

  attr_reader :data

  def initialize(array)
    @data = if array.class == Vector then array; else array.to_scale; end
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