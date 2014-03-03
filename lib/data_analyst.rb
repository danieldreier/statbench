require 'statsample'
require_relative 'confidence_interval'
require_relative 'hypothesis_test'
require_relative 'summary_stats'

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

  def mean_test_summary(significance = 0.05)
    result = if HypothesisTest::faster?(@hash, significance)
      "The new configuration is faster."
    elsif HypothesisTest::slower?(@hash,significance)
      "The new configuration is slower."
    else
      "Average response time hasn't changed."
    end
    result
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


  def variance_test_summary(significance = 0.05)
    result = if HypothesisTest::more_consistent?(@hash, significance)
      "The new configuration is more consistent."
    elsif HypothesisTest::more_variable?(@hash, significance)
      "The new configuration is more variable."
    else
      "Variability in response times hasn't changed."
    end
    result
  end
end