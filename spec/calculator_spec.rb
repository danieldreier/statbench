require 'spec_helper'
require_relative '../test/data'

# Run me with:
# rspec spec/calculator_spec.rb --format doc --color

class Calculator
  describe Calculator do
    it 'calculates summary statistics' do 
      calc = Calculator.new
      results = calc.summary_stats(SMALL_DATASET_1)
      results[:iqr].should eql(45.5)
      results[:minimum].should eql(-32)
      results[:maximum].should eql(861)
      results[:quartile_1].should eql(32.5)
      results[:quartile_3].should eql(78.0)
      results[:median].should eql(58.5)
      results[:upper_fence].should eql(126.75)
      results[:lower_fence].should eql(-9.75)
    end

    it 'identifies outliers' do
      calc = Calculator.new
      results = calc.find_outliers(SMALL_DATASET_1)
      results.sort.should eql([-32, -15, 247, 861])
    end

    it 'removes outliers from a data set' do
      calc = Calculator.new
      results = calc.trim(SMALL_DATASET_1)
      results.sort.should eql([22, 24, 24, 25, 40, 42, 42, 47, 48, 56, 61, 66, 
                              68, 74, 78, 78, 78, 97, 98, 99])
    end

########## CONFIDENCE INTERVALS FOR MEAN OF A SINGLE POPULATION ##############

    # z-test criteria are: known sigma AND (large dataset OR normally distributed 
    # population)
    it 'generates a confidence interval for mean of a single population 
    meeting z-test criteria (no population size given)' do 
      calc = Calculator.new 
      results = calc.mean_confidence_interval({ :data => LARGE_DATASET_1, 
                                           :confidence_level => 0.95, 
                                           :sigma => 55, 
                                           :normal => true 
                                        })
      results[:lower].should be_within(0.01).of(-4.11)
      results[:upper].should be_within(0.01).of(20.78)
      results[:confidence_level].should eql(0.95)
    end

    it 'generates a confidence interval for mean of a single population 
    meeting z-test criteria (population size given)' do 
      calc = Calculator.new 
      results = calc.mean_confidence_interval({ :data => LARGE_DATASET_1,
                                                :confidence_level => 0.95,
                                                :sigma => 55,
                                                :population_size => 1000 
                                             })
      results[:lower].should be_within(0.01).of(-3.64)
      results[:upper].should be_within(0.01).of(20.30)
      results[:confidence_level].should eql(0.95)
    end

    # t-test criteria mainly involve failing the z-test; population must be 
    # symmetrical and unimodal
    it 'generates a confidence interval for mean of a single population using 
    a t-test (no population size given)' do
      calc = Calculator.new
      results = calc.mean_confidence_interval({ :data => LARGE_DATASET_1 })
      results[:lower].should be_within(0.01).of(-5.9)
      results[:upper].should be_within(0.01).of(22.57)
      results[:confidence_level].should eql(0.95)
    end

    it 'generates a confidence interval for mean of a single population
    using a t-test (population size given)' do 
      calc = Calculator.new
      results = calc.mean_confidence_interval({ :data => LARGE_DATASET_1,
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
      results = calc.mean_confidence_interval({ :data => SMALL_DATASET_1, 
                                           :confidence_level => 0.95, 
                                           :sigma => 55 
                                        })
      results[:lower].should be_within(0.01).of(69.61)
      results[:upper].should be_within(0.01).of(116.06)
      results[:confidence_level].should eql(0.95)
    end

    it 'generates a confidence interval for mean of a single population using
    a t-test with sigma known (population size given)' do 
      calc = Calculator.new 
      results = calc.mean_confidence_interval({ :data => SMALL_DATASET_1,
                                           :confidence_level => 0.95,
                                           :sigma => 55,
                                           :population_size => 1000
                                        })
      results[:lower].should be_within(0.01).of(69.89)
      results[:upper].should be_within(0.01).of(115.78)
      results[:confidence_level].should eql(0.95)
    end

    # We need to make sure the size it suggests for the sample doesn't change 
    # any of the test criteria! 
    it 'suggests a sample size for a mean confidence interval given a margin
    of error (z-test)' do 
      calc = Calculator.new 
      calc.suggest_sample_size({ :data => LARGE_DATASET_1, 
                                 :parameter => 'mean', 
                                 :confidence_level => 0.95, 
                                 :margin_of_error => 20, 
                                 :sigma => 68
                              }).should be_within(1).of(316)
    end

    it 'suggests a sample size for a mean confidence interval given a 
    margin of error (t-test)' do 
      calc = Calculator.new 
      calc.suggest_sample_size({:data => SMALL_DATASET_1, 
                                :parameter => 'mean', 
                                :confidence_level => 0.95, 
                                :margin_of_error => 97
                              }).should be_within(2).of(51)
    end

########## CONFIDENCE INTERVALS FOR PROPORTION OF A SINGLE POPULATION #########

    it 'generates a confidence interval for proportion of a single population 
    using a large sample and z-test (no population size given)' do
      calc = Calculator.new 
      results = calc.proportion_confidence_interval(LARGE_BINOMIAL_DATASET_1)
      results[:lower].should be_within(0.0001).of(0.3935)
      results[:upper].should be_within(0.0001).of(0.6198)
      results[:confidence_level].should eql(0.95)
    end

    it 'generates a confidence interval for proportion of a single population using 
    a large sample and z-test (population size given)' do 
      calc = Calculator.new
      results = calc.proportion_confidence_interval(LARGE_BINOMIAL_DATASET_1,0.99,1000)
      results[:lower].should be_within(0.0001).of(0.3560)
      results[:upper].should be_within(0.0001).of(0.6573)
      results[:confidence_level].should eql(0.99)
    end

    it 'generates a Wilson score interval for proportion of a single 
    population and small sample' do 
      calc = Calculator.new
      results = calc.proportion_confidence_interval(SMALL_BINOMIAL_DATASET_1)
      results[:lower].should be_within(0.0001).of(0.3575)
      results[:upper].should be_within(0.0001).of(0.8018) 
      results[:confidence_level].should eql(0.95)
    end

    it 'suggests a sample size for a proportion confidence interval given 
    a margin of error (z-test)' do 
      calc = Calculator.new 
      calc.suggest_sample_size_proportion({ :data => LARGE_BINOMIAL_DATASET_1,  
                                            :confidence_level => 0.95, 
                                            :margin_of_error => 0.1
                                         }).should be_within(2).of(384) 
    end

    it 'suggests a sample size for a proportion confidence interval given
    a margin of error (Wilson scores)' do 
      calc = Calculator.new 
      calc.suggest_sample_size_proportion({ :data => SMALL_DATASET_1, 
                                            :confidence_level => 0.95, 
                                            :margin_of_error => 0.3
                                         }).should be_within(2).of(146) 
    end

##### CONFIDENCE INTERVALS FOR STANDARD DEVIATION OF A SINGLE POPULATION ######

    it 'generates a confidence interval for standard deviation of a single 
    population and small sample' do 
      calc = Calculator.new 
      results = calc.sdev_confidence_interval(SMALL_DATASET_1, 0.9)
      results[:lower].should be_within(0.01).of(138.74)
      results[:upper].should be_within(0.01).of(227.42) 
      results[:confidence_level].should eql(0.9)
    end

    it 'generates a confidence interval for standard deviation of a single 
    population and large sample' do 
      calc = Calculator.new 
      results = calc.sdev_confidence_interval(LARGE_DATASET_1,0.95)
      results[:lower].should be_within(0.01).of(53.30) 
      results[:upper].should be_within(0.01).of(73.73)
      results[:confidence_level].should eql(0.95)
    end

    it 'suggests a sample size for a standard deviation confidence interval
    given a margin of error' do 
      calc = Calculator.new 
      calc.suggest_sample_size_sdev( { :data => LARGE_DATASET_1, 
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