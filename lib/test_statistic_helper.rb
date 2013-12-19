require 'distribution'
require 'statistics2'

module TestStatisticHelper
  include Distribution
  include Statistics2

  ## Initialization methods 

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
    when :t then initialize_t(hash)
    when :f then initialize_f(hash)
    else raise(ArgumentError,'Only t and F distributions currently supported')
    end
  end

  ## Modification Methods

  def edit_attribute(statistic,attribute,new_attribute_value)
    raise(ArgumentError,"Error: Value must be instance of TestStatistic class") unless statistic.instance_of?(TestStatistic)
    attribute_hash = statistic.attributes
    attribute_hash.delete(:value)
    action = lambda { |key,var| attribute_hash[key] = var = new_attribute_value }
    error_message = 'Error: Invalid attribute for test statistic distribution'

    case
    when attribute == 'value'
      action.yield(:value,'value')

    when attribute == 'alpha' || attribute == 'p' || attribute == 'significance_level'
      action.yield(:p,'p')

    when attribute == 'degrees_of_freedom' || attribute == 'nu'
      raise(error_message) unless attribute_hash[:distribution] == :t
      if attribute_hash.has_key?(:nu) then action.yield(:nu,'nu')
      else action.yield(:degrees_of_freedom,'nu'); end

    when attribute == 'tail'
      raise(error_message) unless attribute_hash[:distribution] == :f
      action.yield(:tail,'tail')

    when attribute == 'degrees_of_freedom_1' || attribute == 'nu1'
      raise(error_message) unless attribute_hash[:distribution] == :f
      if attribute_hash.has_key?(:nu1) then action.yield(:nu1,'nu1')
      else action.yield(:degrees_of_freedom_1,'nu1'); end

    when attribute == 'degrees_of_freedom_2' || attribute == 'nu2'
      raise(error_message) unless attribute_hash[:distribution] == :f
      if attribute_hash.has_key?(:nu2) then action.yield(:nu2,'nu2')
      else action.yield(:degrees_of_freedom_2,'nu2'); end

    when attribute == 'distribution'   
      action.yield(:distribution,'distribution')
    end
    
    self.initialize_with(attribute_hash)

  end
end

