require 'spec_helper'

# Run me with:
# rspec spec/calculator_spec.rb --format doc --color

class Calculator
  describe Calculator do
  SAMPLE_DATASET=[66, 40, 78, 22, 48, 78, 24, 24, 25, 99, 74, 98, 97, 42, 61, 42, 78, 68, 56, 47, -32, -15, 247, 861]
    it 'calculates summary statistics' do 
      calc = Calculator.new
      results = calc.summary_stats(SAMPLE_DATASET)
      results[:iqr].should == 45.5
      results[:minimum].should == -32
      results[:maximum].should == 861
      results[:quartile_1].should == 32.5
      results[:quartile_3].should == 78.0
      results[:median].should == 58.5
      results[:upper_fence].should == 126.75
      results[:lower_fence].should == -9.75
    end

    it 'identifies outliers' do
      calc = Calculator.new
      results = calc.find_outliers(SAMPLE_DATASET)
      results.sort.should == [-32, -15, 247, 861]
    end

    it 'removes outliers from a data set' do
      calc = Calculator.new
      results = calc.trim(SAMPLE_DATASET)
      results.sort.should == [22, 24, 24, 25, 40, 42, 42, 47, 48, 56, 61, 66, 68, 74, 78, 78, 78, 97, 98, 99]
    end
  end
end
