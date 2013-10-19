require 'spec_helper'

# Run me with:
# rspec spec/calculator_spec.rb --format doc --color

class Calculator
  describe Calculator do
  SAMPLE_DATASET=[66, 40, 78, 22, 48, 78, 24, 24, 25, 99, 74, 98, 97, 42, 61, 42, 78, 68, 56, 47, -32, -15, 247, 861]
  LARGE_DATASET = [171, 27, 65, 120, 167, 42, 198, 114, 6, 32, 178, 142, 4, 100, 134, 187, 65, 112, 3, 6, 57, 17, 20, 136, 92, 133, 30, 21, 177, 9, 160, 185, 146, 124, 102, 40, 186, 195, 67, 25]
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

    # z-test criteria are: known sigma AND (large dataset OR normally distributed population)
    it 'generates a confidence interval for mean of a population meeting z-test criteria' do 
      calc = Calculator.new 
      results = calc.confidence_interval(LARGE_DATASET, 'mean', 0.95, 55, true)
      results[0].should be_close(77.83, 0.01)
      results[1].should be_close(111.92, 0.01)
    end

    # t-test criteria mainly involve failing the z-test; population must be symmetrical and unimodal
    it 'generates a confidence interval for mean using a t-test' do
      calc = Calculator.new
      results = calc.confidence_interval(LARGE_DATASET, 'mean', 0.95)
      results[0].should be_close(73.72, 0.01)
      results[1].should be_close(116.03, 0.01)
    end

    # if sigma is known but (non-normal distribution && small sample), have to do a t-test
    it 'generates a confidence interval for a mean using a t-test when sigma is known but the other z criteria arent met' do 
      calc = Calculator.new
      results = calc.confidence_interval(SAMPLE_DATASET, 'mean', 0.95, 55)
      results[0].should be_close(69.61, 0.01)
      results[1].should be_close(116.06, 0.01)
    end
  end
end
