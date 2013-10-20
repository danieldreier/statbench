require 'spec_helper'

# Run me with:
# rspec spec/calculator_spec.rb --format doc --color

class Calculator
  describe Calculator do
  SAMPLE_DATASET=[66, 40, 78, 22, 48, 78, 24, 24, 25, 99, 74, 98, 97, 42, 61, 42, 78, 68, 56, 47, -32, -15, 247, 861]
  LARGE_DATASET = [171, 27, 65, 120, 167, 42, 198, 114, 6, 32, 178, 142, 4, 100, 134, 187, 65, 112, 3, 6, 57, 17, 20, 136, 92, 133, 30, 21, 177, 9, 160, 185, 146, 124, 102, 40, 186, 195, 67, 25]
  SMALL_BINOMIAL_DATASET = [1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0]
  LARGE_BINOMIAL_DATASET = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ]
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

################################ CONFIDENCE INTERVALS FOR MEAN OF A SINGLE POPULATION ##################################################

    # z-test criteria are: known sigma AND (large dataset OR normally distributed population)
    it 'generates a confidence interval for mean of a single population meeting z-test criteria' do 
      calc = Calculator.new 
      results = calc.confidence_interval(LARGE_DATASET, 'mean', 0.95, 55, true)
      results[:lower].should be_close(77.83, 0.01)
      results[:upper].should be_close(111.92, 0.01)
      results[:confidence_level].should == 0.95
    end

    # t-test criteria mainly involve failing the z-test; population must be symmetrical and unimodal
    it 'generates a confidence interval for mean of a single population using a t-test' do
      calc = Calculator.new
      results = calc.confidence_interval(LARGE_DATASET, 'mean')
      results[:lower].should be_close(73.72, 0.01)
      results[:upper].should be_close(116.03, 0.01)
      results[:confidence_level].should == 0.95
    end

    # if sigma is known but (non-normal distribution && small sample), have to do a t-test
    it 'generates a confidence interval for mean of a single population using a t-test, sigma known, other z criteria not met' do 
      calc = Calculator.new
      results = calc.confidence_interval(SAMPLE_DATASET, 'mean', 0.95, 55)
      results[:upper].should be_close(69.61, 0.01)
      results[:lower].should be_close(116.06, 0.01)
      results[:confidence_level].should == 0.95
    end

    # We need to make sure the size it suggests for the sample doesn't change any of the test criteria! 
    it 'suggests a sample size for desired confidence interval and z-test (mean)' do 
      calc = Calculator.new 
      calc.suggest_sample_size(LARGE_DATASET, 'mean', 0.95, 20, 71).should be_close(194, 1) # args are parameter, CL, desired range, sigma
    end

    it 'suggests a sample size for desired confidence interval and t-test (mean)' do 
      calc = Calculator.new 
      calc.suggest_sample_size(SAMPLE_DATASET, 'mean', 0.95, 97).should be_close(51, 2) # args are parameter, CL, desired range
    end

############################# CONFIDENCE INTERVALS FOR PROPORTION OF A SINGLE POPULATION ###############################################

    it 'generates a confidence interval for proportion of a single population using a large sample and z-test' do
      calc = Calculator.new 
      results = calc.confidence_interval(LARGE_BINOMIAL_DATASET, 'proportion')
      results[:lower].should be_close(0.5636, 0.0001)
      results[:upper].should be_close(0.2472, 0.0001)
      results[:confidence_level].should == 0.95
    end

    # This is a Wilson score interval! We will need to decide if this is actually the best test for proportion with a small sample
    it 'generates a Wilson score interval for proportion of a single population and small sample' do 
      calc = Calculator.new
      results = calc.confidence_interval(SMALL_BINOMIAL_DATASET, 'proportion')
      results[:lower].should be_close(0.3575, 0.0002)
      results[:upper].should be_close(0.8018, 0.0002) 
      results[:confidence_level].should == 0.95
    end

    it 'suggests a sample size for desired CI using z-test for proportion' do 
      calc = Calculator.new 
      calc.suggest_sample_size(LARGE_DATASET, 'proportion', 0.95, 0.1).should be_close(370, 2) 
    end

    it 'suggests a sample size for desired CI using Wilson scores for proportion' do 
      calc = Calculator.new 
      calc.suggest_sample_size(SAMPLE_DATASET, 'proportion', 0.95, 0.3).should be_close(146, 2) 
    end

######################### CONFIDENCE INTERVALS FOR STANDARD DEVIATION OF A SINGLE POPULATION ###########################################

    it 'generates a confidence interval for standard deviation of a single population and small sample' do 
      calc = Calculator.new 
      results = calc.confidence_interval(SAMPLE_DATASET, 'stdev', 0.9)
      results[:lower].should be_close(138.74, 0.01)
      results[:upper].should be_close(227.42, 0.01) 
      results[:confidence_level].should == 0.9
    end

    it 'generates a confidence interval for standard deviation of a single population and large sample' do 
      calc = Calculator.new 
      results = calc.confidence_interval(LARGE_DATASET, 'stdev')
      results[:lower].should be_close(54.19, 0.01) 
      results[:upper].should be_close(84.94)
      results[:confidence_level].should == 0.95
    end

    it 'suggests a sample size for the desired CI for standard deviation' do 
      calc = Calculator.new 
      calc.suggest_sample_size(LARGE_DATASET, 'stdev', 0.95, 18.76).should be_close(100, 2)
    end
  end
end
