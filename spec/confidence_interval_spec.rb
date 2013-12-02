require_relative 'spec_helper'
require_relative '../test_data'

# Run me with:
# rspec spec/confidence_interval_spec.rb --format nested --color

module ConfidenceInterval
  describe ConfidenceInterval do 
    ALLOWABLE_ERROR = 0.00005

    it 'includes confidence level in output' do 
      result = ConfidenceInterval::confidence_interval({ :data => LARGE_DATASET_1 })
      result.should have_key(:confidence_level)
    end

    it 'assumes confidence level of 95% when not specified' do
      result = ConfidenceInterval::confidence_interval('mean', { :data => LARGE_DATASET_1 })
      result[:confidence_level].should eql(0.95)
    end

    it 'uses user-specified confidence level when such exists' do 
      result = ConfidenceInterval::confidence_level( 'mean', 
                                                   { :data => LARGE_DATASET_1,
                                                     :confidence_level => 0.9 })
      result[:lower].should be_within(ALLOWABLE_ERROR).of(-3.5657)
      result[:upper].should be_within(ALLOWABLE_ERROR).of(20.2324)
      result[:confidence_level].should eql(0.9)
    end

    it 'assumes mean as parameter when not specified' do 
      result = ConfidenceInterval::confidence_interval( { :data => LARGE_DATASET_1 })
      result[:parameter].should eql('mean')
    end

    describe 'interval for a single-population parameter' do 
     it 'treats dependent data sets as a single sample' do 
        result = ConfidenceInterval::confidence_interval( 'mean',
                                                        { :dataset_1        => SMALL_DATASET_3,
                                                          :dataset_2        => SMALL_DATASET_4,
                                                          :confidence_level => 0.99 },
                                                          true )
        result[:lower].should be_within(ALLOWABLE_ERROR).of(-40.5397)
        result[:upper].should be_within(ALLOWABLE_ERROR).of(42.0397)
      end # 'treats dependent data sets as a single sample'

      describe 'mean confidence interval' do 
        context 'meeting z criteria' do 
          # i.e., known sigma; unimodal, symmetrical dist. OR n > 60
          context 'without population size given' do 
            it 'generates mean confidence interval' do 
              result = ConfidenceInterval::confidence_interval( 'mean',
                                                              { :data             => LARGE_DATASET_1,
                                                                :confidence_level => 0.95,
                                                                :sigma            => 55 })
              result[:lower].should be_within(ALLOWABLE_ERROR).of(-4.1141)
              result[:upper].should be_within(ALLOWABLE_ERROR).of(20.7808)
            end # 'generates mean confidence interval', 'w/o pop. size'
          end # 'without population size given'

          context 'with population size given' do 
            it 'generates accurate mean confidence interval' do 
              result = ConfidenceInterval::confidence_interval( 'mean',
                                                              { :data             => LARGE_DATASET_1,
                                                                :confidence_level => 0.95,
                                                                :sigma            => 55,
                                                                :population_size  => 1000 })
              result[:lower].should be_within(ALLOWABLE_ERROR).of(-3.6382)
              result[:upper].should be_within(ALLOWABLE_ERROR).of(20.3049)
            end # 'generates mean confidence interval' 'w/pop size'
          end # 'with population size given'
        end # 'meeting z-test criteria'

        context 'not meeting z criteria' do
          # i.e., unknown sigma or small sample (n < 60)
          # distribution still assumed to be unimodal and symmetrical
          context 'without population size given' do 
            it 'generates a mean confidence interval' do 
              result = ConfidenceInterval::confidence_interval( 'mean', 
                                                              { :data             => SMALL_DATASET_1,
                                                                :sigma            => 55,
                                                                :confidence_level => 0.95 })
              result[:lower].should be_within(ALLOWABLE_ERROR).of(69.6089)
              result[:upper].should be_within(ALLOWABLE_ERROR).of(116.0578)
            end # 'generates a mean confidence interval' 'w/o n-pop'
          end # 'without population size given'

          context 'with population size given' do 
            it 'generates a mean confidence interval' do 
              result = ConfidenceInterval::confidence_interval( 'mean',
                                                              { :data            => LARGE_DATASET_1,
                                                                :population_size => 1000 })
              result[:lower].should be_within(ALLOWABLE_ERROR).of(-5.3563)
              result[:upper].should be_within(ALLOWABLE_ERROR).of(22.0230)
            end # 'generates a mean confidence interval'
          end # 'with population size given'
        end # 'not meeting z criteria'
      end # 'mean confidence interval'

      describe 'proportion confidence interval' do 
        context 'meeting z criteria' do 
          # relevant z criteria are:
          # => Sample includes at least 10 successes and 10 failures
          # => Sample must be simple random sample
          # => Sample can constitute no more than 10% of the population
          context 'without population size given' do 
            it 'generates a z-interval for proportion' do 
              result = ConfidenceInterval::confidence_interval( 'proportion',
                                                              { :data => LARGE_BINOMIAL_DATASET_1 })
              result[:lower].should be_within(ALLOWABLE_ERROR).of(0.3935)
              result[:upper].should be_within(ALLOWABLE_ERROR).of(0.6198)
            end # 'generates a z-interval for proportion'
          end # 'without population size given'

          context 'with population size given' do 
            it 'generates a z-interval for proportion' do 
              result = ConfidenceInterval::confidence_interval( 'proportion',
                                                              { :data             => LARGE_BINOMIAL_DATASET_1,
                                                                :population_size  => 1000,
                                                                :confidence_level => 0.99 })
              result[:lower].should be_within(ALLOWABLE_ERROR).of(0.3560)
              result[:upper].should be_within(ALLOWABLE_ERROR).of(0.6573)
            end # 'generates a z-interval for proportion'
          end # 'with population size given' 
        end # 'meeting z criteria'

        context 'not meeting z criteria' do 
          it 'generates a Wilson interval for proportion' do 
            result = ConfidenceInterval::confidence_interval( 'proportion',
                                                            { :data => SMALL_BINOMIAL_DATASET_1 })
            result[:lower].should be_within(ALLOWABLE_ERROR).of(0.3575)
            result[:upper].should be_within(ALLOWABLE_ERROR).of(0.8018)
          end # 'generates a Wilson interval for proportion'
        end # 'not meeting z criteria'
      end # 'proportion confidence interval'

      describe 'standard deviation confidence interval' do 
        context 'two-tailed' do 
          it 'generates a chi-square interval for standard deviation' do 
            result = ConfidenceInterval::confidence_interval( 'standard deviation',
                                                              { :data => LARGE_DATASET_1,
                                                                :tail => 'both',
                                                                :confidence_level => 0.95 })
            result[:lower].should be_within(ALLOWABLE_ERROR).of(53.3041)
            result[:upper].should be_within(ALLOWABLE_ERROR).of(73.7276)
          end # 'generates a chi-square interval for standard deviation'
        end #'two-tailed'

        context 'one-tailed' do 
          it 'differentiates between left- and right-tailed tests' do 
            result_1 = ConfidenceInterval::confidence_interval( 'standard deviation',
                                                              { :data => LARGE_DATASET_1,
                                                                :tail => 'left' })
            result_2 = ConfidenceInterval::confidence_interval( 'standard deviation',
                                                              { :data => LARGE_DATASET_1,
                                                                :tail => 'right' })
            result_1.should_not eql(result_2)
          end # 'differentiates between left- and right-tailed intervals'

          it 'generates a right-tailed interval for standard deviation' do
            # In its current form this test actually demands, and receives, a maximum value
            # for sigma rather than an interval. This is one of several issues with the 
            # CI module slated to be rectified very soon.
            result = ConfidenceInterval::confidence_interval( 'standard deviation',
                                                            { :data             => LARGE_DATASET_1,
                                                              :tail             => 'right',
                                                              :confidence_level => 0.95 })
            result.should be_within(ALLOWABLE_ERROR).of(71.6374)
          end # 'generates a right-tailed interval for standard deviation'

          it 'generates a left-tailed interval for standard deviation' do 
            # The comment under right-tailed applies to this as well
            result = ConfidenceInterval::confidence_interval( 'standard_deviation',
                                                            { :data             => LARGE_DATASET_1,
                                                              :tail             => 'left',
                                                              :confidence_level => 0.95 })
            result.should be_within(ALLOWABLE_ERROR).of(54.5774)
          end # 'generates a left-tailed interval for standard deviation' 
        end # 'one-tailed'
      end # 'standard deviation confidence interval'
    end # 'interval for a single-population parameter'

    describe 'interval for difference between params of 2 populations' do 
      describe 'difference between two means' do 
        context 'meeting z criteria' do 
          it 'generates a z interval for difference between two means' do 
            result = ConfidenceInterval::confidence_interval( 'mean', 
                                                            { :dataset_1        => LARGE_DATASET_1,
                                                              :dataset_2        => LARGE_DATASET_2,
                                                              :sigma_1          => 60,
                                                              :sigma_2          => 45,
                                                              :confidence_level => 0.95 
                                                            })
            result[:lower].should be_within(ALLOWABLE_ERROR).of(-73.7287)
            result[:upper].should be_within(ALLOWABLE_ERROR).of(-34.7500)     
          end # 'generates a z interval for difference between two means' 
        end # 'meeting z criteria'

        context 'not meeting z criteria' do 
          context 'unknown sigmas presumed equal, large samples' do 
            it 'generates a t-interval for difference between two means' do 
                result = ConfidenceInterval::confidence_interval( 'mean', 
                                                                { :dataset_1        => LARGE_DATASET_2,
                                                                  :dataset_2        => LARGE_DATASET_3,
                                                                  :confidence_level => 0.99 
                                                                })
                result[:lower].should be_within(ALLOWABLE_ERROR).of(-31.7866)
                result[:upper].should be_within(ALLOWABLE_ERROR).of(5.6489)
              end # 'generates a t-interval for difference between two means'
            end # 'unknown sigmas presumed equal, large samples'

          context 'known sigmas, small samples' do 
            it 'generates a t-interval for difference between two means' do 
              result = ConfidenceInterval::confidence_interval( 'mean', 
                                                              { :dataset_1        => SMALL_DATASET_2,
                                                                :dataset_2        => SMALL_DATASET_3,
                                                                :sigma_1          => 35,
                                                                :sigma_2          => 40,
                                                                :confidence_level => 0.99 
                                                              })
              result[:lower].should be_within(ALLOWABLE_ERROR).of(-35.7185)
              result[:upper].should be_within(ALLOWABLE_ERROR).of(39.1185)
            end # 'generates a t-interval for difference between two means'
          end # 'known sigmas, small samples'

          context 'unknown sigmas presumed unequal' do 
            it 'generates interval for difference between two means' do 
              pending 'better statistical tools needed'
            end # 'generates interval for difference between two means'
          end # 'unknown sigmas presumed unequal'
        end # 'not meeting z criteria'
      end # 'difference between two means'

      describe 'difference between two proportions' do 
        context 'meeting z criteria' do 
          it 'generates interval for difference between two proportions' do 
            result = ConfidenceInterval::confidence_interval( 'proportion',
                                                            { :dataset_1        => LARGE_BINOMIAL_DATASET_1,
                                                              :dataset_2        => LARGE_BINOMIAL_DATASET_2,
                                                              :confidence_level => 0.95 })
            result[:lower].should be_within(ALLOWABLE_ERROR).of(-0.0130)
            result[:upper].should be_within(ALLOWABLE_ERROR).of(0.2946)
          end # 'generates interval for difference between two proportions'
        end # 'meeting z criteria'

        context 'not meeting z criteria' do 
          it 'generates interval for difference between two proportions' do 
            pending 'deciding on the best approach'
          end # 'generates interval for difference between two proportions'
        end # 'not meeting z criteria'
      end # 'difference between two proportions'

      describe 'difference between two standard deviations' do 
        context 'two-tailed' do 
          pending 'researching/developing appropriate techniques'
        end

        context 'one-tailed' do 
          pending 'researching/developing appropriate techniques'
        end
      end # 'difference between two standard deviations'
    end # 'interval for difference between params of 2 populations' 
  end # ConfidenceInterval
end # module ConfidenceInterval