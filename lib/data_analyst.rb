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
    @data1 = process_file(data1)
    @data2 = process_file(data2)
    process_data
  end

  def process_data(data1=@data1,data2=@data2)
    @hash = { 'nu1' => @data1.size - 1, 'mean1' => @data1.mean.round(4), 'var1' => @data1.variance_sample.round(4),
              'nu2' => @data2.size - 1, 'mean2' => @data2.mean.round(4), 'var2' => @data2.variance_sample.round(4)
            }
  end

  def process_file(file)
    arr = Array.new
    File.open(file,'r+') do |file|
      file.each_line do |line|
        arr << line.chomp!.to_f
      end
    end
    arr.to_scale
  end

  def summary_stats
    stats = {:old_config => nil, :new_config => nil}
    [@data1,@data2].each do |dataset|
      # Summary statistics include min, max, median, iqr, upper fence, and lower fence
      min = dataset.min; max = dataset.max 
      upper_fence = (median = dataset.median + (fence_range = 1.5 * (iqr = (q2 = dataset.percentil(75)) - (q1 = dataset.percentil(25)))))
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