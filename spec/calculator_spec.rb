require 'spec_helper'

# Run me with:
# rspec spec/calculator_spec.rb --format doc --color

class Calculator
  describe Calculator do
  SAMPLE_DATASET=[ 66, 40, 78, 22, 48, 78, 24, 24, 25, 99, 74, 98, 97, 42, 61, 
                   42, 78, 68, 56, 47, -32, -15, 247, 861 ]
  LARGE_DATASET = [-68, -25, -98, -97, -71, 34, -32, -24, 83, -83, 81, 42,
                    80, 53, 4, -60, 76, 31, -32, 87, -86, 100, 70, 15, -22, 
                    40, 18, 13, 48, 5, 41, -97, 37, -39, 48, 21, 98, 78, 
                    93, 14, 98, 20, 8, -63, -56, -99, 36, 66, -21, 0, -4,
                    96, 19, -67, -69, -20, 92, 64, 46, -1, 13, 77, -95, 62,
                   -85, -91, 67, 86, 12, -15, -99, 16, -73, 66, 63 ]
  SMALL_BINOMIAL_DATASET = [ 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0 ]
  LARGE_BINOMIAL_DATASET = [ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 
                             1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
                             1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0,
                             0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
                             0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ]
    it 'calculates summary statistics' do 
      calc = Calculator.new
      results = calc.summary_stats(SAMPLE_DATASET)
      results[:iqr].should == 45.5
      results[:minimum].should == -32
      results[:maximum].should == 861
      results[:quartile_1].should == 32.5
      results[:quartile_3].should == 78.0
      results[:median].should == 58.5
      results[:upper_fence].should == 146.25
      results[:lower_fence].should == -35.75
    end

    it 'identifies outliers' do
      calc = Calculator.new
      results = calc.find_outliers(SAMPLE_DATASET)
      results.sort.should == [247, 861]
    end

    it 'removes outliers from a data set' do
      calc = Calculator.new
      results = calc.trim(SAMPLE_DATASET)
      results.sort.should == [-32, -15, 22, 24, 24, 25, 40, 42, 42, 47, 48, 56, 61, 66, 
                              68, 74, 78, 78, 78, 97, 98, 99]
    end

########## CONFIDENCE INTERVALS FOR MEAN OF A SINGLE POPULATION ##############

    # z-test criteria are: known sigma AND (large dataset OR normally distributed 
    # population)
    it 'generates a confidence interval for mean of a single population 
    meeting z-test criteria (no population size given)' do 
      calc = Calculator.new 
      results = calc.mean_confidence_interval({ :data => LARGE_DATASET, 
                                           :confidence_level => 0.95, 
                                           :sigma => 55, 
                                           :normal => true 
                                        })
      results[:lower].should be_within(0.01).of(-4.11)
      results[:upper].should be_within(0.01).of(20.78)
      results[:confidence_level].should == 0.95
    end

    it 'generates a confidence interval for mean of a single population 
    meeting z-test criteria (population size given)' do 
      calc = Calculator.new 
      results = calc.mean_confidence_interval({ :data => LARGE_DATASET,
                                                :confidence_level => 0.95,
                                                :sigma => 55,
                                                :population_size => 1000 
                                             })
      results[:lower].should be_within(0.01).of(-3.64)
      results[:upper].should be_within(0.01).of(20.30)
      results[:confidence_level].should == 0.95
    end

    # t-test criteria mainly involve failing the z-test; population must be 
    # symmetrical and unimodal
    it 'generates a confidence interval for mean of a single population using 
    a t-test (no population size given)' do
      calc = Calculator.new
      results = calc.mean_confidence_interval({ :data => LARGE_DATASET })
      results[:lower].should be_within(0.01).of(-5.9)
      results[:upper].should be_within(0.01).of(22.57)
      results[:confidence_level].should == 0.95
    end

    it 'generates a confidence interval for mean of a single population
    using a t-test (population size given)' do 
      calc = Calculator.new
      results = calc.mean_confidence_interval({ :data => LARGE_DATASET,
                                                :population_size => 1000
                                              })
      results[:lower].should be_within(0.01).of(-5.36)
      results[:upper].should be_within(0.01).of(22.02)
    end

    # if sigma is known but (non-normal distribution && small sample), have to 
    # do a t-test
    it 'generates a confidence interval for mean of a single population using 
    a t-test, sigma known, other z criteria not met (no population size)' do 
      calc = Calculator.new
      results = calc.mean_confidence_interval({ :data => SAMPLE_DATASET, 
                                           :confidence_level => 0.95, 
                                           :sigma => 55 
                                        })
      results[:lower].should be_within(0.01).of(69.61)
      results[:upper].should be_within(0.01).of(116.06)
      results[:confidence_level].should == 0.95
    end

    it 'generates a confidence interval for mean of a single population using
    a t-test with sigma known (population size given)' do 
      calc = Calculator.new 
      results = calc.mean_confidence_interval({ :data => SAMPLE_DATASET,
                                           :confidence_level => 0.95,
                                           :sigma => 55,
                                           :population_size => 1000
                                        })
      results[:lower].should be_within(0.01).of(69.89)
      results[:upper].should be_within(0.01).of(115.78)
      results[:confidence_level].should == 0.95
    end

    # The range in question is the total size of the desired confidence interval -
    # not the margin of error
    it 'suggests a sample size for a mean confidence interval given a margin
    of error (z-test)' do 
      calc = Calculator.new 
      calc.suggest_sample_size_mean({ :confidence_level => 0.95, 
                                      :range => 40, 
                                      :sigma => 68
                                   }).should be_within(1).of(44)
    end

    it 'suggests a sample size for a mean confidence interval given a 
    margin of error (t-test)' do 
      calc = Calculator.new 
      calc.suggest_sample_size_mean({:data => SAMPLE_DATASET,  
                                     :confidence_level => 0.95, 
                                     :range => 194
                                   }).should be_within(1).of(51)
    end

########## CONFIDENCE INTERVALS FOR PROPORTION OF A SINGLE POPULATION #########

    it 'generates a confidence interval for proportion of a single population 
    using a large sample and z-test (no population size given)' do
      calc = Calculator.new 
      results = calc.proportion_confidence_interval(LARGE_BINOMIAL_DATASET)
      results[:lower].should be_within(0.0001).of(0.3935)
      results[:upper].should be_within(0.0001).of(0.6198)
      results[:confidence_level].should == 0.95
    end

    it 'generates a confidence interval for proportion of a single population using 
    a large sample and z-test (population size given)' do 
      calc = Calculator.new
      results = calc.proportion_confidence_interval(LARGE_BINOMIAL_DATASET,0.99,1000)
      results[:lower].should be_within(0.0001).of(0.3560)
      results[:upper].should be_within(0.0001).of(0.6573)
      results[:confidence_level].should == 0.99
    end

    it 'generates a Wilson score interval for proportion of a single 
    population and small sample' do 
      calc = Calculator.new
      results = calc.proportion_confidence_interval(SMALL_BINOMIAL_DATASET)
      results[:lower].should be_within(0.0001).of(0.3575)
      results[:upper].should be_within(0.0001).of(0.8018) 
      results[:confidence_level].should == 0.95
    end

    it 'suggests a sample size for a proportion confidence interval given 
    a margin of error (z-test)' do 
      calc = Calculator.new 
      calc.suggest_sample_size_proportion({ :data => LARGE_BINOMIAL_DATASET,  
                                            :confidence_level => 0.95, 
                                            :margin_of_error => 0.1
                                         }).should be_within(2).of(384) 
    end

    it 'suggests a sample size for a proportion confidence interval given
    a margin of error (Wilson scores)' do 
      calc = Calculator.new 
      calc.suggest_sample_size_proportion({ :data => SAMPLE_DATASET, 
                                            :confidence_level => 0.95, 
                                            :margin_of_error => 0.3
                                         }).should be_within(2).of(146) 
    end

##### CONFIDENCE INTERVALS FOR STANDARD DEVIATION OF A SINGLE POPULATION ######

    it 'generates a two-tailed confidence interval for standard deviation 
    of a single population' do 
      calc = Calculator.new
      results = calc.sdev_confidence_interval_2t({ :data => LARGE_DATASET,
                                                   :confidence_level => 0.95
                                                })
      results[:lower].should be_within(0.01).of(53.30)
      results[:upper].should be_within(0.01).of(73.73)
      results[:confidence_level].should == 0.95
    end

    it 'generates a left-tailed confidence interval for standard deviation
    of a single population' do 
      calc = Calculator.new
      results = calc.sdev_confidence_interval_lower({ :data => LARGE_DATASET,
                                                      :confidence_level => 0.95 
                                                   })
      results.should be_within(0.01).of(54.58)
    end

    it 'generates a right-tailed confidence interval for standard deviation of 
    a single population' do 
      calc = Calculator.new 
      results = calc.sdev_confidence_interval_upper({ :data => LARGE_DATASET,
                                                      :confidence_level => 0.95 
                                                    })
      results.should be_within(0.01).of(71.64)
    end

    it 'suggests a sample size for a standard deviation confidence interval
    given a margin of error' do 
      calc = Calculator.new 
      calc.suggest_sample_size_sdev( { :data => LARGE_DATASET, 
                                       :confidence_level => 0.95, 
                                       :margin_of_error => 17.5495 
                                   } ).should be_within(2).of(100)
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
require 'spec_helper'

# Run me with:
# rspec spec/calculator_spec.rb --format doc --color
