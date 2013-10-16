require 'spec_helper'

# Run me with:
# rspec spec/calculator_spec.rb --format doc --color

class Calculator
  describe Calculator do
    it 'calculates summary statistics' do 
      calc = Calculator.new
      results = calc.summary_stats([1, 5, 10, 20, 50, 1])
      results[:iqr].should == 19
      results[:minimum].should == 1
      results[:maximum].should == 50
      results[:quartile_1].should == 1
      results[:quartile_3].should == 20
      results[:median].should == 7.5
      results[:upper_fence].should == 36.0
      results[:lower_fence].should == -21.0
    end

    it 'identifies outliers' do
      calc = Calculator.new
      results = calc.find_outliers([66, 40, 78, 22, 48, 78, 24, 24, 25, 99, 74, 98, 97, 42, 61, 42, 78, 68, 56, 47, -32, -15, 247, 861])
      results.sort.should == [-32, -15, 247, 861]
    end

    it 'removes outliers from a data set' do
      calc = Calculator.new
      results = calc.trim([66, 40, 78, 22, 48, 78, 24, 24, 25, 99, 74, 98, 97, 42, 61, 42, 78, 68, 56, 47, -32, -15, 247, 861])
      results.sort.should == [22, 24, 24, 25, 40, 42, 42, 47, 48, 56, 61, 66, 68, 74, 78, 78, 78, 97, 98, 99]
    end
  end
end