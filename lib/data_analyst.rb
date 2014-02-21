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

  def initialize(data1,data2)
    @data1 = standardize_data(data1)
    @data2 = standardize_data(data2)
    process_data
  end

  def process_data(data1=@data1,data2=@data2)
    @hash = { 'nu1' => @data1.size - 1, 'mean1' => @data1.mean.round(4), 'var1' => @data1.variance_sample.round(4),
              'nu2' => @data2.size - 1, 'mean2' => @data2.mean.round(4), 'var2' => @data2.variance_sample.round(4)
            }
  end

  def process_file(data_file)
    arr = Array.new
    File.open(data_file,'r+') do |file|
      file.each_line do |line|
        arr << line.chomp!.to_f
      end
    end
    arr.to_scale
  end

  def standardize_data(data)
    if (data.instance_of? File) || (data.instance_of? String)
      puts "Processing input file..."
      process_file(data)
    elsif data.instance_of? Array
      data.to_scale
    elsif data.instance_of? Vector
      data
    else 
      raise(ArgumentError,"Data must be array, vector/scale or file")
    end
  end

  def summary_stats
    stats = {:old_config => nil, :new_config => nil}
    [@data1,@data2].each do |dataset|
      # Summary statistics include min, max, median, iqr, upper fence, and lower fence
      min = dataset.min; max = dataset.max 
      upper_fence = (median = dataset.median + (fence_range = 1.5 * (iqr = (q1 = dataset.percentil(25)) - (q2 = dataset.percentil(75)))))
      lower_fence = median - fence_range

      stats.each do |key, value|
        if value == nil         # Note: We have a variable scope issue here
          value = { :min => min,
                    :max => max, 
                    :median => median, 
                    :iqr => iqr, 
                    :upper_fence => upper_fence, 
                    :lower_fence => lower_fence }
          break
        end
      end
    end
    stats
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