require 'statsample'

class Calculator
  include Statsample::SRS
  # output summary stats of input array (min, max, median, 1st & 3rd quartiles, IQR, upper & lower fences) as a hash
  def summary_stats(array)
    @data = array.to_vector(:scale)
    @summary_stats = Hash.new()
    @summary_stats[:minimum] = @data.min()
    @summary_stats[:maximum] = @data.max()
    @summary_stats[:median] = @data.median()
    @summary_stats[:quartile_1] = @data.percentil(25)
    @summary_stats[:quartile_3] = @data.percentil(75)
    @summary_stats[:iqr] = @data.percentil(75) - @data.percentil(25)
    @summary_stats[:upper_fence] = @data.median() + @summary_stats[:iqr] * 1.5
    @summary_stats[:lower_fence] = @data.median() - @summary_stats[:iqr] * 1.5
    @summary_stats
  end

  # Return the outliers in a data set. Multiplier is the multiple of the IQR above or below the median above/below which a data point is
  # considered an outlier. We will want to update this method to include other methods of determining outliers.
  def find_outliers(array, multiplier = 1.5)
    @data = array.to_vector(:scale)
    @outliers = Array.new()
    @data.each do |data_point|
      if (data_point < @data.median() - (@data.percentil(75) - @data.percentil(25))*multiplier) || (data_point > @data.median() + (@data.percentil(75) - @data.percentil(25))*1.5)
        @outliers << data_point
      end
    end
    @outliers
  end

  # Return a data set with outliers removed (using the upper/lower fence method of identifying outliers). Multiplier is the multiple of IQR
  # used to determine the fences. We will want to update this method to include other methods of returning outliers.
  def trim(array, multiplier = 1.5)
    array  - self.find_outliers(array, multiplier)
  end

  def t_confidence_interval(sample_stat,multiplier,df,confidence_level=0.95)
    t_critical = Distribution::T.p_value((1 - confidence_level) / 2, df).abs

    { :lower => sample_stat - (margin_of_error = t_critical * multiplier),
      :upper => sample_stat + margin_of_error,
      :confidence_level => confidence_level }

  end

  def z_confidence_interval(sample_stat,multiplier,confidence_level=0.95)
    z_critical = Distribution::Normal.p_value((1 - confidence_level) / 2).abs

    { :lower => sample_stat - (margin_of_error = z_critical*multiplier), 
      :upper => sample_stat + margin_of_error, 
      :confidence_level => confidence_level }
  end


## MEAN CONFIDENCE TESTING ##

  def mean_confidence_interval(hash)
    data = hash[:data].to_scale
    mean = data.mean()
    population_size = hash[:population_size]
    confidence_level = hash[:confidence_level] || 0.95
    n = data.size 
    s = data.standard_deviation_sample

    standard_error = if sigma = hash[:sigma]
      sigma.quo(Math.sqrt(n))
    else 
      s.quo(Math.sqrt(n))
    end

    ci = if sigma && (n >= 60 || hash[:normal] == true)
      if population_size
        ci_array = Statsample::SRS.mean_confidence_interval_z(mean,sigma,n,population_size,confidence_level)
        {:lower => ci_array[0], 
         :upper => ci_array[1], 
         :confidence_level => confidence_level }
      else
        z_confidence_interval(mean,standard_error,confidence_level)
      end
    else
      if population_size
        if sigma
          ci_array = Statsample::SRS.mean_confidence_interval_t(mean,sigma,n,population_size,confidence_level)
        else
          ci_array = Statsample::SRS.mean_confidence_interval_t(mean,s,n,population_size,confidence_level)
        end
        { :lower => ci_array[0], 
          :upper => ci_array[1],
          :confidence_level => confidence_level }
      else
        t_confidence_interval(mean,standard_error,n - 1,confidence_level)
      end
    end
  end

  ## PROPORTION CONFIDENCE TESTING ##

  def proportion_confidence_interval(array,confidence_level=0.95,population_size=nil)
    data = array.to_scale
    n = data.size
    p_hat = data.count(1).quo(n)

    if n >= 60  # Use a z interval
      if population_size
        ci_array = Statsample::SRS.proportion_confidence_interval_z(p_hat,n,population_size,confidence_level)
        { :lower => ci_array[0], :upper => ci_array[1], :confidence_level => confidence_level }
      else
        standard_error = Math.sqrt(p_hat * (1 - p_hat) / n)
        z_confidence_interval(p_hat,standard_error,confidence_level)
      end
    else # Use a Wilson interval 
      wilson_interval(n,p_hat,confidence_level)
    end
  end
  
  def wilson_interval(n,p_hat,confidence_level=0.95)
    z2 = (z = Distribution::Normal.p_value((1 - confidence_level).quo(2)).abs) ** 2
    lower = n.quo(n + z2) * ( p_hat + z2.quo(2 * n) - z * Math.sqrt((p_hat * (1 - p_hat)).quo(n) + z2.quo(4 * n ** 2)))
    upper = n.quo(n + z2) * ( p_hat + z2.quo(2 * n) + z * Math.sqrt((p_hat * (1 - p_hat)).quo(n) + z2.quo(4 * n ** 2)))
    { :lower => lower, :upper => upper, :confidence_level => confidence_level }
  end

  ## VARIANCE CONFIDENCE TESTING ##

  # Two-tailed confidence interval for population variance using chi-square dist.
  def variance_confidence_interval_2t(hash)
    data = hash[:data].to_scale
    s2 = (hash[:s] || data.standard_deviation_sample()) ** 2
    df = if hash[:n_sample] then hash[:n_sample] - 1;
      else data.size - 1; end
    confidence_level = hash[:confidence_level] || 0.95
    alpha_over_2 = (1 - confidence_level) / 2  # use to generate test statistics

    chi2_lower = Distribution::ChiSquare.p_value(1 - alpha_over_2, df)
    chi2_upper = Distribution::ChiSquare.p_value(alpha_over_2, df)

    { :lower => s2 * df / chi2_lower, 
      :upper => s2 * df / chi2_upper,
      :confidence_level => confidence_level 
    }
  end

  # 2-tailed confidence interval for population standard deviation
  def sdev_confidence_interval_2t(hash)
    variance_hash = variance_confidence_interval_2t(hash)
    { :lower => Math.sqrt(variance_hash[:lower]),
      :upper => Math.sqrt(variance_hash[:upper]),
      :confidence_level => variance_hash[:confidence_level]
    }
  end

  # Variance will be greater than or equal to output value with
  # given confidence level
  def variance_confidence_interval_lower(hash)
    data = hash[:data].to_scale
    s2 = (hash[:s] || data.standard_deviation_sample()) ** 2
    df = if hash[:n_sample] then hash[:n_sample] - 1;
      else data.size - 1; end
    confidence_level = hash[:confidence_level] || 0.95
    chi2 = Distribution::ChiSquare.p_value(confidence_level,df)

    s2 * df / chi2 
  end

  # Standard deviation will be greater than or equal to output 
  # value with given confidence level
  def sdev_confidence_interval_lower(hash)
    Math.sqrt( variance_confidence_interval_lower(hash) )
  end

  # Variance will be less than or equal to output value with given
  # confidence level
  def variance_confidence_interval_upper(hash)
    data = hash[:data].to_scale
    s2 = (hash[:s] || data.standard_deviation_sample) ** 2
    df = if hash[:n_sample] then hash[:n_sample] - 1;
      else data.size - 1; end 
    alpha = 1 - (hash[:confidence_level] || 0.95)
    chi2 = Distribution::ChiSquare.p_value(alpha,df)

    s2 * df / chi2 
  end

  # Standard deviation will be less than or equal to output value
  # with given level of confidence
  def sdev_confidence_interval_upper(hash)
    Math.sqrt( variance_confidence_interval_upper(hash) )
  end

  ## SAMPLE SIZE ESTIMATION ##
  def suggest_sample_size_mean(hash)
    confidence_level = hash[:confidence_level] || 0.95
    margin_of_error = hash[:range] / 2
    sigma = hash[:sigma]
    sdev_sample = hash[:sdev_sample]

    if sigma
      z = Distribution::Normal.p_value(1 - ((1 - confidence_level).quo(2.0))).abs 
      ((z * sigma / margin_of_error) ** 2).to_i
    else
      # You're going to need a more difficult test, bro.
    end
  end
end
