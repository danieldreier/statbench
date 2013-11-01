require 'statsample'
require 'distribution'
require 'calculator'

    SAMPLE_DATASET=[ 66, 40, 78, 22, 48, 78, 24, 24, 25, 99, 74, 98, 97, 42, 61, 
                     42, 78, 68, 56, 47, -32, -15, 247, 861 
                   ]
    LARGE_DATASET = [-68, -25, -98, -97, -71, 34, -32, -24, 83, -83, 81, 42,
                      80, 53, 4, -60, 76, 31, -32, 87, -86, 100, 70, 15, -22, 
                      40, 18, 13, 48, 5, 41, -97, 37, -39, 48, 21, 98, 78, 
                      93, 14, 98, 20, 8, -63, -56, -99, 36, 66, -21, 0, -4,
                      96, 19, -67, -69, -20, 92, 64, 46, -1, 13, 77, -95, 62,
                     -85, -91, 67, 86, 12, -15, -99, 16, -73, 66, 63 
                   ]
    SMALL_BINOMIAL_DATASET = [ 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0 ]
    LARGE_BINOMIAL_DATASET = [ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 
                               1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
                               1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0,
                               0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
                               0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ]

module ConfidenceInterval
  # Provides confidence intervals for mean, proportion, variance, and standard deviations
  # given either one or two samples.
  @@calc = Calculator.new

  def mean_confidence_interval(hash)
    calc.mean_confidence_interval(hash)
  end

  def proportion_confidence_interval(hash)
    calc.proportion_confidence_interval(hash)
  end

  def sdev_confidence_interval_2t(hash)
    calc.sdev_confidence_interval_2t(hash)
  end

  def sdev_confidence_interval_lower(hash)
    calc.sdev_confidence_interval_lower(hash)
  end

  def sdev_confidence_interval_upper(hash)
    calc.sdev_confidence_interval_upper(hash)
  end
end

p ConfidenceInterval.mean_confidence_interval({:data => LARGE_DATASET, :confidence_level => 0.95, 
  @sigma => 55, :normal => true})