require 'statsample'
require 'distribution'
require_relative 'test_statistic'

module ConfidenceInterval
  include Statsample
  include TestStatisticHelper

  def confidence_interval(parameter='mean',hash)
    dataset_1        = hash[:dataset_1].to_scale if hash[:dataset_1]
    dataset_2        = hash[:dataset_2].to_scale if hash[:dataset_2]
    n1               = dataset_1.size if dataset_1
    n2               = dataset_2.size if dataset_2
    data             = hash[:data].to_scale if hash[:data]
    n                = data.size if data
    confidence_level = hash[:confidence_level] || 0.95
    param_hash       = if dataset_1 
      { :n1               => n1, 
        :n2               => n2, 
        :confidence_level => confidence_level, 
        :tail             => hash[:tail] 
      }
    else 
      { :n                => n, 
        :confidence_level => confidence_level, 
        :tail             => hash[:tail], 
        :population_size  => hash[:population_size]
      } 
    end

    case parameter
    when 'mean'
      param_hash[:known_sigma] = true if (hash[:sigma_1] && hash[:sigma_2]) || hash[:sigma]

      if dataset_1
        param_hash[:sample_difference] = dataset_1.mean - dataset_2.mean 
        param_hash[:s1]                = hash[:sigma_1] || dataset_1.standard_deviation_sample()
        param_hash[:s2]                = hash[:sigma_2] || dataset_2.standard_deviation_sample()
        two_mean_interval(param_hash)
      else 
        param_hash[:x_bar] = data.mean()
        param_hash[:s]     = hash[:sigma] || data.standard_deviation_sample()
        single_mean_interval(param_hash)
      end

    when 'proportion'
      if dataset_1
        param_hash[:p_hat_1] = dataset_1.count(1).quo( dataset_1.size ).to_f
        param_hash[:p_hat_2] = dataset_2.count(1).quo( dataset_2.size ).to_f
        two_proportion_interval(param_hash)
      else
        param_hash[:p_hat] = data.count(1).quo( data.size ).to_f
        single_proportion_interval(param_hash)
      end

    when 'standard deviation'
      param_hash[:variance] = (data.standard_deviation_sample()) ** 2
      sdev_interval(param_hash)

    when 'variance' 
      param_hash[:variance] = (data.standard_deviation_sample) ** 2
      variance_interval(param_hash)

    else 
      raise(ArgumentError,'Error: Invalid parameter')

    end
  end

  ### MEAN INTERVALS ###
  def equal_sigma?(n1,s1,n2,s2)
    # this will call a method from HypothesisTest!
  end

  def pooled_variance(nu1,var1,nu2,var2)
    (nu1 * var1 + nu2 * var2) / (nu1 + nu2)
  end

  def single_mean_interval(hash)
    n           = hash[:n]
    x_bar       = hash[:x_bar]
    sdev        = hash[:s]
    std_error   = std_error_single_mean(n,sdev)
    alpha       = (1 - (confidence_level = hash[:confidence_level])) / 2
    known_sigma = hash[:known_sigma]
    pop_size    = hash[:population_size]
    use_z       = known_sigma && n >= 60

    if pop_size 
      if use_z
        interval_array = Statsample::SRS.mean_confidence_interval_z(x_bar,sdev,n,pop_size,confidence_level)
      else
        interval_array = Statsample::SRS.mean_confidence_interval_t(x_bar,sdev,n,pop_size,confidence_level)
      end
      lower = interval_array[0]
      upper = interval_array[1]
      margin_of_error = upper - x_bar
    else
      test_stat = if use_z
        TestStatisticHelper::initialize_with({ :distribution => :z, :p => alpha })
      else
        TestStatisticHelper::initialize_with({ :distribution => :t, :p => alpha, :degrees_of_freedom => n - 1 })
      end
    end

    margin_of_error ||= test_stat.abs * std_error

    { :confidence_level => confidence_level,
      :margin_of_error  => margin_of_error,
      :lower            => lower || x_bar - margin_of_error,
      :upper            => upper || x_bar + margin_of_error
    }
  end

  def std_error_single_mean(n,sdev)
    sdev.quo(Math.sqrt(n))
  end

  def std_error_two_mean(n1,sdev1,n2=0,sdev2=0,pool=false)    # Mean standard error for 1 and 2 samples
    if pool then Math.sqrt(pooled_variance(n1-1,sdev1**2,n2-1,sdev2**2)*(1.quo(n1)+1.quo(n2)))
    else Math.sqrt((sdev1**2).quo(n1) + (sdev2 ** 2).quo(n2)); end
  end

  def two_mean_interval(hash)
    n1          = hash[:n1]
    n2          = hash[:n2]
    sdev1       = hash[:s1]
    sdev2       = hash[:s2]
    sample_diff = hash[:sample_difference]
    known_sigma = hash[:known_sigma]
    alpha       = (1 - (confidence_level = hash[:confidence_level])) / 2

    # use z if known sigma and large samples
    use_z = n1 >= 60 && n2 >= 60 && known_sigma

    # use pooling if the difference between the sample variances is less than 15% of the pooled variance
    # replace this method in production version with call to #equal_variance? method
    use_pooling = ((sdev1 ** 2 - sdev2 ** 2).abs / pooled_variance(n1-1,sdev1**2,n2-1,sdev2**2) < 0.15 ) && !known_sigma

    std_error = std_error_two_mean(n1,sdev1,n2,sdev2,use_pooling)

    test_stat = if use_z
      TestStatisticHelper::initialize_with({ :distribution => :z, :p => alpha })
    else
      df = if use_pooling then n1 + n2 - 2; elsif n1 < n2 then n1-1; else n2-1; end 
      TestStatisticHelper::initialize_with({ :distribution => :t, :p => alpha, :degrees_of_freedom => df })
    end

    margin_of_error = test_stat.abs * std_error 
    { :confidence_level => confidence_level, 
      :margin_of_error => margin_of_error,
      :lower => sample_diff - margin_of_error,
      :upper => sample_diff + margin_of_error 
    }
  end

  ### PROPORTION INTERVALS ### 

  def std_error_one_proportion(n,p_hat)
    Math.sqrt( p_hat * (1 - p_hat) / n)
  end

  def std_error_two_proportion(n1,p_hat_1,n2,p_hat_2)
    Math.sqrt( p_hat_1 * (1-p_hat_1).quo(n1) + p_hat_2 * (1-p_hat_2).quo(n2))
  end

  def single_proportion_interval(hash)
    n               = hash[:n]
    n_pop           = hash[:population_size]
    p_hat           = hash[:p_hat]
    std_error       = std_error_one_proportion(n,p_hat)
    alpha           = (1 - (confidence_level = hash[:confidence_level])) / 2
    interval        = { }
    z               = TestStatisticHelper::initialize_with({ :distribution => :z, :p => alpha })
    z_interval      = n >= 60

    if n_pop
      interval = Statsample::SRS.proportion_confidence_interval_z(p_hat,n,n_pop,confidence_level)
      lower           = interval[0]
      upper           = interval[1]
      margin_of_error = upper - p_hat
    elsif z_interval
      margin_of_error = z.abs * std_error
      lower = p_hat - margin_of_error
      upper = p_hat + margin_of_error
    else
      wilson_interval = wilson_interval(n,p_hat,z)
    end

    wilson_interval || { :confidence_level => confidence_level, 
                         :margin_of_error => margin_of_error, 
                         :lower => lower, 
                         :upper => upper }
  end

  def two_proportion_interval(hash)
    n1              = hash[:n1]
    n2              = hash[:n2]
    p_hat_1         = hash[:p_hat_1]
    p_hat_2         = hash[:p_hat_2]
    std_error       = std_error_two_proportion(n1,p_hat_1,n2,p_hat_2)
    sample_diff     = p_hat_1 - p_hat_2
    alpha           = (1 - (confidence_level = hash[:confidence_level])) / 2
    z               = TestStatisticHelper::initialize_with({ :distribution => :z, :p => alpha })
    margin_of_error = z.abs * std_error

    { :confidence_level => confidence_level,
      :margin_of_error  => margin_of_error,
      :lower            => sample_diff - margin_of_error,
      :upper            => sample_diff + margin_of_error
    }
  end

  def wilson_interval(n,p_hat,z)
    z2 = z ** 2
    lower = n.quo(n + z2) * ( p_hat + z2.quo(2 * n) - z.abs * Math.sqrt((p_hat * (1 - p_hat)).quo(n) + z2.quo(4 * n ** 2)))
    upper = n.quo(n + z2) * ( p_hat + z2.quo(2 * n) + z.abs * Math.sqrt((p_hat * (1 - p_hat)).quo(n) + z2.quo(4 * n ** 2)))
    margin_of_error = (upper - lower).quo(2)
    { :confidence_level => 1 - (2 * z.alpha), :margin_of_error => margin_of_error, :lower => lower, :upper => upper }
  end

  ### VARIANCE AND STANDARD DEVIATION INTERVALS ### 

  def sdev_ceiling(hash)
    Math.sqrt(variance_ceiling(hash))
  end

  def sdev_floor(hash)
    Math.sqrt(variance_floor(hash))
  end

  def sdev_interval(hash)
    interval = variance_interval(hash)
    interval[:lower] = Math.sqrt(interval[:lower])
    interval[:upper] = Math.sqrt(interval[:upper]) if interval[:upper]
    interval[:margin_of_error] = 0.5*(interval[:upper] - interval[:lower]) if hash[:tail] == 'both'
    interval
  end

  def variance_ceiling(hash)
    alpha = 1 - hash[:confidence_level]
    nu = hash[:n] - 1
    s2 = hash[:variance]
    chi2 = TestStatisticHelper::initialize_with({ :distribution       => :chi2,
                                                  :tail               => 'left',
                                                  :p                  => alpha,
                                                  :degrees_of_freedom => nu })
    s2 * nu / chi2
  end

  def variance_floor(hash)
    alpha = 1 - hash[:confidence_level]
    nu = hash[:n] - 1 
    s2 = hash[:variance]
    chi2 = TestStatisticHelper::initialize_with({ :distribution       => :chi2, 
                                                  :tail               => 'right',
                                                  :p                  => alpha,
                                                  :degrees_of_freedom => nu })
    s2 * nu / chi2 
  end

  def variance_interval(hash)
    case hash[:tail]
    when 'both'
      variance_interval_2t(hash)
    when 'left'
      { :confidence_level => hash[:confidence_level], :lower => variance_floor(hash), :upper => nil }
    when 'right'
      { :confidence_level => hash[:confidence_level], :lower => 0, :upper => variance_ceiling(hash) }
    else
      raise(ArgumentError,"Error: Please specify tail 'left', 'right', or 'both'")
    end
  end

  def variance_interval_2t(hash)
    variance = hash[:variance]
    alpha = (1 - (confidence_level = hash[:confidence_level])) / 2 
    df = hash[:n] - 1
    chi2_upper = TestStatisticHelper::initialize_with({ :distribution       => :chi2,
                                                        :tail               => 'left',
                                                        :degrees_of_freedom => df,
                                                        :p                  => alpha
                                                      })
    chi2_lower = TestStatisticHelper::initialize_with({ :distribution       => :chi2, 
                                                        :tail               => 'right',
                                                        :degrees_of_freedom => df,
                                                        :p                  => alpha
                                                     })
    lower = variance * df / chi2_lower
    upper = variance * df / chi2_upper
    margin_of_error = (upper - lower) / 2
    { :confidence_level => confidence_level, :margin_of_error => margin_of_error, :lower => lower, :upper => upper }
  end
end