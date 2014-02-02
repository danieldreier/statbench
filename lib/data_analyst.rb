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
    @data1 = process_file(file1)
    @data2 = process_file(file2)
    process_data
  end

  def change_data(existing_dataset,new_data)
    case existing_dataset
    when "old" || "data1"
      @data1 = if new_data.class == Vector then new_data; else new_data.to_scale; end 
    when "new" || "data2"
      @data2 = if new_data.class == Vector then new_data; else new_data.to_scale; end 
    end
  end

  def process_data
    @hash = { 'nu1' => @data1.size - 1, 'mean1' => @data1.mean.round(4), 'var1' => @data1.variance_sample.round(4),
              'nu2' => @data2.size - 1, 'mean2' => @data2.mean.round(4), 'var2' => @data2.variance_sample.round(4)
            }
  end

  def process_file(data_file)
    arr = Array.new
    File.open(data_file) do |file|
      file.each_line do |line|
        arr << line.chomp!.to_f
      end
    end
    arr.to_scale
  end

  def summary_stats
    # TBD
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