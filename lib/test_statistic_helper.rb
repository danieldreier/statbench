require 'distribution'
require 'statistics2'

module TestStatisticHelper
  include Distribution
  include Statistics2

  ## Initialization methods 

  def initialize_chi2(hash)
    if hash[:value]
      output = TestStatistic.new(hash[:value])

    else
      p = hash[:p] || hash[:alpha]
      nu = hash[:degrees_of_freedom]
      tail = hash[:tail]

      if tail == 'right'
        output = TestStatistic.new(Distribution::ChiSquare.p_value(1-p,nu))
      elsif tail == 'left'
        output = TestStatistic.new(Distribution::ChiSquare.p_value(p,nu))
      else
        raise('Please specify a tail or instantiate two TestStatistics for two-tailed test.')
      end

    end
    output.add_attributes(hash)
    output
  end

  def initialize_f(hash)
    nu1  = hash[:degrees_of_freedom_1]
    nu2  = hash[:degrees_of_freedom_2]
    tail = hash[:tail]

    if hash[:value]
      output   = TestStatistic.new(hash.delete(:value))
      hash[:p] = if tail == 'right' then 1 - Statistics2.fdist(nu1,nu2,output)
      elsif tail == 'left' then Statistics2.fdist(nu1,nu2,output)
      else raise('Please specify a tail or instantiate two F statistics for a two-tailed test.'); end
    else
      p = hash[:p] || hash[:alpha]
      tail = hash[:tail]

      if tail == 'right'
        output = TestStatistic.new(Distribution::F.p_value(1-p,nu1,nu2))
      elsif tail == 'left'
        output = TestStatistic.new(Distribution::F.p_value(p,nu1,nu2))
      else
        raise('Please specify a tail or instantiate two F statistics for two-tailed test.')
      end
    end

    output.add_attributes(hash)
    output
  end

  def initialize_t(hash)
    # Set the value of the test statistic based on whatever information is
    # given in the hash.test
    if hash[:value]
      output = TestStatistic.new(t=hash[:value]) 
      if hash[:degrees_of_freedom]
        # As with initialize_z, the p-value refers to the tail area and is
        # NOT equal to the cumulative distribution function for a given t > 0.
        hash[:p] = if t <= 0 then Distribution::T.cdf(t,hash[:degrees_of_freedom])
        else 1 - Distribution::T.cdf(t,hash[:degrees_of_freedom]); end     

      elsif hash[:p] || hash[:alpha] || hash[:significance_level]
        # Calculate the degrees of freedom based on the values of p and t
        # This one still needs work 
      end
    else
      p = hash[:p] || hash[:alpha] || hash[:significance_level]
      nu = hash[:degrees_of_freedom] 
      output = TestStatistic.new(Distribution::T.p_value(p,nu))
    end

    output.add_attributes(hash)
    output
  end

  def initialize_with(hash)
    case hash[:distribution]
    when :z then initialize_z(hash)
    when :t then initialize_t(hash)
    when :chi2 then initialize_chi2(hash)
    when :f then initialize_f(hash)
    else raise(ArgumentError,'Error: Need to specify distribution')
    end
  end

  def initialize_z(hash)
    if hash[:value]
      output = TestStatistic.new(z = hash[:value])

      # The p-value is set to be the area IN THE TAIL for both left- and 
      # right-tailed tests. When z > 0, this value is NOT the same as the 
      # value of the cumulative distribution function at z.

      hash[:p] = if z <= 0 then Distribution::Normal.cdf(z)
      else 1 - Distribution::Normal.cdf(z)
      end
    else
      p = hash[:p] || hash[:alpha] || hash[:significance_level]
      output = TestStatistic.new(Distribution::Normal.p_value(p))
    end
    output.add_attributes(hash)
    output
  end

  ## Modification Methods

  def edit_attribute(statistic,attribute,new_attribute_value)
    raise(ArgumentError,"Error: Value must be instance of TestStatistic class") unless statistic.is_a?(TestStatistic)
    attribute_hash = statistic.attributes
    attribute_hash.delete(:value)
    action = lambda { |key,var| attribute_hash[key] = var = new_attribute_value }
    error_message = 'Error: Invalid attribute for test statistic distribution'

    case
    when attribute == 'value'
      action.yield(:value,'value')

    when attribute == 'alpha' || attribute == 'p'
      action.yield(:p,'p')

    when attribute == 'degrees_of_freedom' || attribute == 'nu'
      if attribute_hash[:distribution] == :z || attribute_hash[:distribution] == :f
        raise(error_message)
      else 
        if attribute_hash.has_key?(:nu) then action.yield(:nu,'nu')
        else action.yield(:degrees_of_freedom,'nu'); end
      end

    when attribute == 'tail'
      unless attribute_hash[:distribution] == :chi2 || attribute_hash[:distribution] == :f
        raise(error_message)
      else
        action.yield(:tail,'tail')
      end

    when attribute == 'degrees_of_freedom_1' || attribute == 'nu1'
      unless attribute_hash[:distribution] == :f
        raise(error_message)
      else
        if attribute_hash.has_key?(:nu1) then action.yield(:nu1,'nu1')
        else action.yield(:degrees_of_freedom_1,'nu1'); end
      end

    when attribute == 'degrees_of_freedom_2' || attribute == 'nu2'
      unless attribute_hash[:distribution] == :f
        raise(error_message)
      else
        if attribute_hash.has_key?(:nu2) then action.yield(:nu2,'nu2')
        else action.yield(:degrees_of_freedom_2,'nu2'); end
      end

    when attribute == 'distribution'   
      action.yield(:distribution,'distribution')
    end
    
    self.initialize_with(attribute_hash)

  end
end

