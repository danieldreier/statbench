require 'spec_helper'
require_relative '../test/data'

# Run me with:
# rspec spec/interval_spec.rb --format doc --color

module ConfidenceInterval
  describe ConfidenceInterval do
    ALLOWABLE_TESTING_ERROR  = 0.00005
                             
    #################### CONFIDENCE INTERVALS FOR MEAN #####################

    # z-test criteria are: known sigma AND (large dataset OR normally distributed 
    # population)
    it 'generates a confidence interval for mean of a single population 
    meeting z criteria (no population size given)' do               
      results = ConfidenceInterval::confidence_interval( 'mean',
                                                       { :data             => LARGE_DATASET_1, 
                                                         :confidence_level => 0.95, 
                                                         :sigma            => 55, 
                                                       })
      results[:lower].should be_within(ALLOWABLE_TESTING_ERROR).of(-4.1141)
      results[:upper].should be_within(ALLOWABLE_TESTING_ERROR).of(20.7808)
      results[:confidence_level].should == 0.95
    end

    it 'generates a confidence interval for mean of a single population 
    meeting z criteria (population size given)' do                   
      results = ConfidenceInterval::confidence_interval( 'mean',
                                                       { :data             => LARGE_DATASET_1,
                                                         :confidence_level => 0.95,
                                                         :sigma            => 55,
                                                         :population_size  => 1000 
                                                       })
      results[:lower].should be_within(ALLOWABLE_TESTING_ERROR).of(-3.6382)
      results[:upper].should be_within(ALLOWABLE_TESTING_ERROR).of(20.3049)
      results[:confidence_level].should == 0.95
    end

    # t criteria mainly involve not meeting z criteria; population must be 
    # symmetrical and unimodal
    it 'generates a confidence interval for mean of a single population using 
    a t-test (no population size given)' do                        
      results = ConfidenceInterval::confidence_interval( 'mean', { :data => LARGE_DATASET_1 })
      results[:lower].should be_within(ALLOWABLE_TESTING_ERROR).of(-5.9005)
      results[:upper].should be_within(ALLOWABLE_TESTING_ERROR).of(22.5672)
      results[:confidence_level].should == 0.95
    end

    it 'generates a confidence interval for mean of a single population
    using a t-test (population size given)' do                      
      results = ConfidenceInterval::confidence_interval( 'mean', 
                                                       { :data            => LARGE_DATASET_1,
                                                         :population_size => 1000
                                                       })
      results[:lower].should be_within(ALLOWABLE_TESTING_ERROR).of(-5.3563)
      results[:upper].should be_within(ALLOWABLE_TESTING_ERROR).of(22.0230)
    end

    # if sigma is known but (non-normal distribution && small sample), have to 
    # do a t-test
    it 'generates a confidence interval for mean of a single population using 
    a t-test, sigma known, other z criteria not met (no population size)' do 
      results = ConfidenceInterval::confidence_interval( 'mean',
                                                       { :data             => SMALL_DATASET_1, 
                                                         :confidence_level => 0.95, 
                                                         :sigma            => 55 
                                                       })
      results[:lower].should be_within(ALLOWABLE_TESTING_ERROR).of(69.6089)
      results[:upper].should be_within(ALLOWABLE_TESTING_ERROR).of(116.0578)
      results[:confidence_level].should == 0.95
    end

    it 'generates a confidence interval for mean of a single population using
    a t-statistic with sigma known (population size given)' do                 
      results = ConfidenceInterval::confidence_interval( 'mean',
                                                       { :data             => SMALL_DATASET_1,
                                                         :confidence_level => 0.95,
                                                         :sigma            => 55,
                                                         :population_size  => 1000
                                                       })
      results[:lower].should be_within(ALLOWABLE_TESTING_ERROR).of(69.8893)
      results[:upper].should be_within(ALLOWABLE_TESTING_ERROR).of(115.7774)
      results[:confidence_level].should == 0.95
    end

    it 'generates a confidence interval for the difference between two means
    using a z-statistic (population sdevs known, large samples)' do           
      results = ConfidenceInterval::confidence_interval( 'mean', 
                                                       { :dataset_1        => LARGE_DATASET_1,
                                                         :dataset_2        => LARGE_DATASET_2,
                                                         :sigma_1          => 60,
                                                         :sigma_2          => 45,
                                                         :confidence_level => 0.95 
                                                       })
      results[:lower].should be_within(ALLOWABLE_TESTING_ERROR).of(-73.7287)
      results[:upper].should be_within(ALLOWABLE_TESTING_ERROR).of(-3475)
      results[:confidence_level].should == 0.95
    end

    it 'generates a confidence interval for the difference between two means
    using a t-statistic (population sdevs unknown, equal, large samples' do   
      results = ConfidenceInterval::confidence_interval( 'mean', 
                                                       { :dataset_1        => LARGE_DATASET_2,
                                                         :dataset_2        => LARGE_DATASET_3,
                                                         :confidence_level => 0.99 
                                                       })
      results[:lower].should be_within(ALLOWABLE_TESTING_ERROR).of(-31.7866)
      results[:upper].should be_within(ALLOWABLE_TESTING_ERROR).of(5.6489)
      results[:confidence_level].should == 0.99
    end

    it 'generates a confidence interval for the difference between two means
    using a t-statistic (population sdevs known, small samples)' do           
      results = ConfidenceInterval::confidence_interval( 'mean', 
                                                       { :dataset_1        => SMALL_DATASET_2,
                                                         :dataset_2        => SMALL_DATASET_3,
                                                         :sigma_1          => 35,
                                                         :sigma_2          => 40,
                                                         :confidence_level => 0.99 
                                                       })
      results[:lower].should be_within(ALLOWABLE_TESTING_ERROR).of(-35.7185)
      results[:upper].should be_within(ALLOWABLE_TESTING_ERROR).of(39.1185)
      results[:confidence_level].should == 0.99
    end

    it "generates a confidence interval for the difference between two means
    where population sdevs are unknown and believed to be unequal" do       

      # NOTE: The method tested here relies on a less accurate estimate of the confidence interval
      #       due to the inability of the Distribution module to return t-values with fractional
      #       degrees of freedom. The method will need to be rewritten incorporating a more
      #       accurate calculation. As currently written, the t-value used to construct the confidence
      #       interval takes its degrees as freedom from the smaller sample - i.e. if n1 = 25 and n2 = 17,
      #       t will be based on 16 degrees of freedom.

      results = ConfidenceInterval::confidence_interval( 'mean',
                                                       { :dataset_1        => SMALL_DATASET_1,
                                                         :dataset_2        => SMALL_DATASET_2 
                                                       })
      results[:lower].should be_within(ALLOWABLE_TESTING_ERROR).of(-47.1087)
      results[:upper].should be_within(ALLOWABLE_TESTING_ERROR).of(103.3754)
      results[:confidence_level].should == 0.95
    end

    it 'treats dependent samples as a single data set' do 
      results = ConfidenceInterval::confidence_interval( 'mean',
                                                       { :dataset_1        => SMALL_DATASET_3,
                                                         :dataset_2        => SMALL_DATASET_4,
                                                         :confidence_level => 0.99 }, 
                                                         true 
                                                       )
      results[:lower].should be_within(ALLOWABLE_TESTING_ERROR).of(-40.5397)
      results[:upper].should be_within(ALLOWABLE_TESTING_ERROR).of(42.0397)
      results[:confidence_level].should == 0.99
    end

    ################# CONFIDENCE INTERVALS FOR PROPORTION ################

    it 'generates a confidence interval for proportion of a single population 
    using a large sample and z-test (no population size given)' do           
      results = ConfidenceInterval::confidence_interval( 'proportion', { :data => LARGE_BINOMIAL_DATASET_1 })
      results[:lower].should be_within(ALLOWABLE_TESTING_ERROR).of(0.3935)
      results[:upper].should be_within(ALLOWABLE_TESTING_ERROR).of(0.6198)
      results[:confidence_level].should == 0.95
    end

    it 'generates a confidence interval for proportion of a single population using 
    a large sample and z-test (population size given)' do                    
      results = ConfidenceInterval::confidence_interval( 'proportion', 
                                                       { :data             => LARGE_BINOMIAL_DATASET_1,
                                                         :confidence_level => 0.99,
                                                         :population_size  => 1000 
                                                       })
      results[:lower].should be_within(ALLOWABLE_TESTING_ERROR).of(0.3560)
      results[:upper].should be_within(ALLOWABLE_TESTING_ERROR).of(0.6573)
      results[:confidence_level].should == 0.99
    end

    it 'generates a Wilson score interval for proportion of a single 
    population and small sample' do                                         
      results = ConfidenceInterval::confidence_interval( 'proportion',
                                                       { :data => SMALL_BINOMIAL_DATASET_1 
                                                       })
      results[:lower].should be_within(ALLOWABLE_TESTING_ERROR).of(0.3575)
      results[:upper].should be_within(ALLOWABLE_TESTING_ERROR).of(0.8018) 
      results[:confidence_level].should == 0.95
    end

    it 'generates a confidence interval for the difference between two 
    population proportions with samples following z guidelines' do 
      # "z guidelines" means each sample must contain at least 10 successes and
      # 10 failures, and the samples must be independent of one another. As always,
      # simple random samples are expected.
      results = ConfidenceInterval::confidence_interval( 'proportion',
                                                       { :dataset_1        => LARGE_BINOMIAL_DATASET_1,
                                                         :dataset_2        => LARGE_BINOMIAL_DATASET_2,
                                                         :confidence_level => 0.95 
                                                       })
      results[:lower].should be_within(ALLOWABLE_TESTING_ERROR).of(-0.0130)
      results[:upper].should be_within(ALLOWABLE_TESTING_ERROR).of(0.2946)
      results[:confidence_level].should == 0.95
    end

    it 'generates a confidence interval for the difference between two 
    population proportions with samples not meething z guidelines' do 
      results = ConfidenceInterval::confidence_interval( 'proportion',
                                                       { :dataset_1        => SMALL_BINOMIAL_DATASET_1,
                                                         :dataset_2        => SMALL_BINOMIAL_DATASET_2,
                                                         :confidence_level => 0.95 
                                                       })
      specify do
        pending
      end
    end

    ########## CONFIDENCE INTERVALS FOR STANDARD DEVIATION ###########

    it 'generates a two-tailed confidence interval for standard deviation 
    of a single population' do                                             
      results = ConfidenceInterval::confidence_interval( 'standard deviation',
                                                       { :data             => LARGE_DATASET_1,
                                                         :tail             => 'both',
                                                         :confidence_level => 0.95
                                                       })
      results[:lower].should be_within(ALLOWABLE_TESTING_ERROR).of(53.3041)
      results[:upper].should be_within(ALLOWABLE_TESTING_ERROR).of(73.7276)
      results[:confidence_level].should == 0.95
    end

    it 'generates a left-tailed confidence interval for standard deviation
    of a single population' do                                            
      results = ConfidenceInterval::confidence_interval( 'standard deviation',
                                                       { :data             => LARGE_DATASET_1,
                                                         :tail             => 'left',
                                                         :confidence_level => 0.95 
                                                       })
      results.should be_within(ALLOWABLE_TESTING_ERROR).of(54.5774)
    end

    it 'generates a right-tailed confidence interval for standard deviation of 
    a single population' do                                              
      results = ConfidenceInterval::confidence_interval( 'standard deviation',
                                                       { :data             => LARGE_DATASET_1,
                                                         :tail             => 'right',
                                                         :confidence_level => 0.95 
                                                                         })
      results.should be_within(ALLOWABLE_TESTING_ERROR).of(71.6364)
    end

    it 'generates a two-tailed confidence interval for standard deviation of two 
    populations' do 
      specify do 
        pending
      end
    end
  end
end