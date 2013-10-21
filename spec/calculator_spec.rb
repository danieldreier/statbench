require 'spec_helper'

# Run me with:
# rspec spec/calculator_spec.rb --format doc --color

class Calculator
  describe Calculator do
  SAMPLE_DATASET=[66, 40, 78, 22, 48, 78, 24, 24, 25, 99, 74, 98, 97, 42, 61, 
                  42, 78, 68, 56, 47, -32, -15, 247, 861]
  LARGE_DATASET = [-68, -25, -98, -97, -71, 34, -32, -24, 83, -83, 81, 42,
                    80, 53, 4, -60, 76, 31, -32, 87, -86, 100, 70, 15, -22 
                    40, 18, 13, 48, 5, 41, -97, 37, -39, 48, 21, 98, 78, 
                    93, 14, 98, 20, 8, -63, -56, -99, 36, 66, -21, 0, -4,
                    96, 19, -67, -69, -20, 92, 64, 46, -1, 13, 77, -95, 62
                    -85, -91, 67, 86, 12, -15, -99, 16, -73, 66, 63]
  SMALL_BINOMIAL_DATASET = [ 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0 ]
  LARGE_BINOMIAL_DATASET = [ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 
                             1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
                             1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0,
                             0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
                             0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
                           ]
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
      results.sort.should == [22, 24, 24, 25, 40, 42, 42, 47, 48, 56, 61, 66, 
                              68, 74, 78, 78, 78, 97, 98, 99]
    end

########## CONFIDENCE INTERVALS FOR MEAN OF A SINGLE POPULATION ##############

    # z-test criteria are: known sigma AND (large dataset OR normally distributed 
    # population)
    it 'generates a confidence interval for mean of a single population 
    meeting z-test criteria' do 
      calc = Calculator.new 
      results = calc.confidence_interval({ :data => LARGE_DATASET, 
                                           :parameter => 'mean', 
                                           :confidence_level => 0.95, 
                                           :sigma => 55, 
                                           :normal_population => true 
                                        })
      results[:lower].should be_close(-4.11, 0.01)
      results[:upper].should be_close(20.78, 0.01)
      results[:confidence_level].should == 0.95
    end

    # t-test criteria mainly involve failing the z-test; population must be 
    # symmetrical and unimodal
    it 'generates a confidence interval for mean of a single population using 
    a t-test' do
      calc = Calculator.new
      results = calc.confidence_interval({ :data => LARGE_DATASET, 
                                           :parameter => 'mean' 
                                        })
      results[:lower].should be_close(-5.90, 0.01)
      results[:upper].should be_close(22.57, 0.01)
      results[:confidence_level].should == 0.95
    end

    # if sigma is known but (non-normal distribution && small sample), have to 
    # do a t-test
    it 'generates a confidence interval for mean of a single population using 
    a t-test, sigma known, other z criteria not met' do 
      calc = Calculator.new
      results = calc.confidence_interval({ :data => SAMPLE_DATASET, 
                                           :parameter => 'mean', 
                                           :confidence_level => 0.95, 
                                           :sigma => 55 
                                        })
      results[:upper].should be_close(69.61, 0.01)
      results[:lower].should be_close(116.06, 0.01)
      results[:confidence_level].should == 0.95
    end

    # We need to make sure the size it suggests for the sample doesn't change 
    # any of the test criteria! 
    it 'suggests a sample size for desired confidence interval and z-test 
    (mean)' do 
      calc = Calculator.new 
      calc.suggest_sample_size({ :data => LARGE_DATASET, 
                                 :parameter => 'mean', 
                                 :confidence_level => 0.95, 
                                 :desired_range => 20, 
                                 :sigma => 68
                              }).should be_close(316, 1)
    end

    it 'suggests a sample size for desired confidence interval and t-test 
    (mean)' do 
      calc = Calculator.new 
      calc.suggest_sample_size({:data => SAMPLE_DATASET, 
                                :parameter => 'mean', 
                                :confidence_level => 0.95, 
                                :desired_range => 97
                              }).should be_close(51, 2)
    end

########## CONFIDENCE INTERVALS FOR PROPORTION OF A SINGLE POPULATION #########

    it 'generates a confidence interval for proportion of a single population 
    using a large sample and z-test' do
      calc = Calculator.new 
      results = calc.confidence_interval({ :data => LARGE_BINOMIAL_DATASET, 
                                           :parameter => 'proportion'
                                        })
      results[:lower].should be_close(0.3935, 0.0001)
      results[:upper].should be_close(0.6198, 0.0001)
      results[:confidence_level].should == 0.95
    end

    # This is a Wilson score interval! We will need to decide if this is 
    # actually the best test for proportion with a small sample
    it 'generates a Wilson score interval for proportion of a single 
    population and small sample' do 
      calc = Calculator.new
      results = calc.confidence_interval(SMALL_BINOMIAL_DATASET, 'proportion')
      results[:lower].should be_close(0.3575, 0.0002)
      results[:upper].should be_close(0.8018, 0.0002) 
      results[:confidence_level].should == 0.95
    end

    it 'suggests a sample size for desired CI using z-test for proportion' do 
      calc = Calculator.new 
      calc.suggest_sample_size({ :data => LARGE_BINOMIAL_DATASET, 
                                 :parameter => 'proportion', 
                                 :confidence_level => 0.95, 
                                 :desired_range => 0.1
                              }).should be_close(384, 2) 
    end

    it 'suggests a sample size for desired CI using Wilson scores for 
    proportion' do 
      calc = Calculator.new 
      calc.suggest_sample_size({ :data => SAMPLE_DATASET, 
                                 :parameter => 'proportion', 
                                 :confidence_level => 0.95, 
                                 :desired_range => 0.3
                              }).should be_close(146, 2) 
    end

##### CONFIDENCE INTERVALS FOR STANDARD DEVIATION OF A SINGLE POPULATION ######

    it 'generates a confidence interval for standard deviation of a single 
    population and small sample' do 
      calc = Calculator.new 
      results = calc.confidence_interval({ :data => SAMPLE_DATASET, 
                                           :parameter => 'stdev', 
                                           :confidence_level => 0.9
                                        })
      results[:lower].should be_close(138.74, 0.01)
      results[:upper].should be_close(227.42, 0.01) 
      results[:confidence_level].should == 0.9
    end

    it 'generates a confidence interval for standard deviation of a single 
    population and large sample' do 
      calc = Calculator.new 
      results = calc.confidence_interval({ :data => LARGE_DATASET, 
                                           :parameter => 'stdev'
                                        })
      results[:lower].should be_close(53.30, 0.01) 
      results[:upper].should be_close(73.73, 0.01)
      results[:confidence_level].should == 0.95
    end

    it 'suggests a sample size for the desired CI for standard deviation' do 
      calc = Calculator.new 
      calc.suggest_sample_size( { :data => LARGE_DATASET, 
                                  :parameter => 'stdev', 
                                  :confidence_level => 0.95, 
                                  :desired_range => 17.5495 } ).should be_close(100, 2)
    end
  end
end

# WILSON INTERVALS:
# a = 1 / ( 1 + z^2 / n)
# b = z^2 / (2n)
# c = (phatq/n + z^2/(4n^2))

# lower bound is:
#   a * [ phat + b + z * sqrt c]

# lower bound is:
#   a * [ phat + b - z * sqrt c ]
