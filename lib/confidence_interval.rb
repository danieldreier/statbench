require 'statsample'

module ConfidenceInterval
  include Statsample
  
  # The get_variables method is also present in HypothesisTest.
  # When we refactor we will want to extract these to DRY it up.
  def get_variables(hash)
    hash.each do |key,value|
      name = '@' + key
      instance_variable_set(name,value)
    end
  end

  def mean_difference(hash=@hash)
    get_variables(hash)
    @mean1 - @mean2
  end

  def sdev_difference(hash=@hash)
    get_variables(hash)
    (@sdev1 ||= Math.sqrt(@var1)) - (@sdev2 ||= Math.sqrt(@var2))
  end
end