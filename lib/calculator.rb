require 'statsample'

class Calculator
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

  # Print a boxplot depicting data
  def boxplot(array)	# This should be modified to take any number of arrays as arguments and generate boxplots for all
    @data = array.to_vector(:scale)
    puts Statsample::Graph::Boxplot.new(:vectors=>[@data]).to_svg
  end

  # Return the outliers in a data set. Multiplier is the IQR multiplier used to determine upper and lower fences. We will want to update
  # this method to include other methods of identifying outliers.
  def find_outliers(array, multiplier = 1.5)
    @data = array.to_vector(:scale)
    @outliers = Array.new()
    @data.each do |data_point|
      if (data_point < @data.median() - (@data.percentil(75) - @data.percentil(25))*multiplier) || (data_point > @data.median() + (@data.percentil(75) - @data.percentil(25))*multiplier)
        @outliers << data_point
      end
    end
    @outliers
  end

  # Return a data set with outliers removed (using the upper/lower fence method of identifying outliers). Multiplier is the multiple of IQR used
  # to determine the fences. We will want to update this method to include other methods of returning outliers.
  def trim(array, multiplier = 1.5)
    @data = array.to_vector(:scale)
    @data.each do |data_point|
      if (data_point < @data.median() - (@data.percentil(75) - @data.percentil(25))*multiplier) || (data_point > @data.median() - (@data.percentil(75) - @data.percentil(25))*multiplier)
        @data.delete(data_point)
      end
    end
    @data
  end
end
