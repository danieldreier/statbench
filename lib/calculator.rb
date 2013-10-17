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
end
