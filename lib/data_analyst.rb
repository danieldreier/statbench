require 'statsample'
require_relative 'confidence_interval'
require_relative 'hypothesis_test'

class DataAnalyst
  include Statsample
  include HypothesisTest
  include ConfidenceInterval

  attr_reader :data1
  attr_reader :data2
  attr_reader :hash

  def initialize(file1,file2)
    data1 = Array.new; data2 = Array.new
    File.open(file1) do |file|
      file.each_line do |line|
        data1 << line.chomp!.to_f
      end
    end
    File.open(file2) do |file|
      file.each_line do |line|
        data2 << line.chomp!.to_f
      end
    end
    @data1 = data1.to_scale
    @data2 = data2.to_scale
    process
  end

  def process
    @hash = { 'nu1' => @data1.size - 1, 'mean1' => @data1.mean.round(4), 'var1' => @data1.variance_sample.round(4),
              'nu2' => @data2.size - 1, 'mean2' => @data2.mean.round(4), 'var2' => @data2.variance_sample.round(4)
            }
  end

  def change_data(existing_dataset,new_data)
    case existing_dataset
    when "old" || "data1"
      @data1 = if new_data.class == Vector then new_data; else new_data.to_scale; end 
    when "new" || "data2"
      @data2 = if new_data.class == Vector then new_data; else new_data.to_scale; end 
    end
  end

  def summary_stats
    #
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