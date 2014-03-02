require 'statsample'

module SummaryStats
  def summary_stats
    stats = {:old_config => nil, :new_config => nil}
    [@data1,@data2].each do |dataset|
      # Summary statistics include min, max, median, iqr, upper fence, and lower fence
      min = dataset.min; max = dataset.max 
      upper_fence = (median = dataset.median + (fence_range = 1.5 * (iqr = (q2 = dataset.percentil(75)) - (q1 = dataset.percentil(25)))))
      lower_fence = median - fence_range

      stats.each do |key, value|
        if value == nil         # Note: We have a variable scope issue here
          value = { :min => min,
                    :max => max, 
                    :median => median, 
                    :iqr => iqr, 
                    :upper_fence => upper_fence, 
                    :lower_fence => lower_fence }
          break
        end
      end
    end
    stats
  end
end