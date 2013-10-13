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
  end
end