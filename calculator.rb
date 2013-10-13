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
end
