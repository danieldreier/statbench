require 'statsample'
require 'distribution'
require_relative 'test_statistic'
require_relative '../test/data'

module HypothesisTest
  include TestStatisticHelper
  def test(hash)
    @data_1    = hash[:dataset_1].to_scale
    @data_2    = hash[:dataset_2].to_scale
    @param     = hash[:parameter] || :mean 
    @sig_level = hash[:significance] || 0.05

    case @param 
    when :mean then test_mean(@data_1,@data_2,@sig_level);
    when :proportion then test_proportion(@data_1,@data_2,@sig_level);
    when :variance then test_variance(@data_1,@data_2,@sig_level);
    when :sdev then test_variance(@data_1,@data_2,@sig_level,true); end
  end

  def test_mean(data1,data2,significance)
    h0        = 'mu1 = mu2'
    h1_left   = 'mu1 < mu2'
    h1_right  = 'mu1 > mu2'
    s1        = data1.standard_deviation_sample
    s2        = data2.standard_deviation_sample
    std_error = Math.sqrt( (s1 ** 2).quo(n1 = data1.size) + (s2 ** 2).quo(n2 = data2.size))
    nu        = (std_error ** 4).quo(((s1 ** 2 / n1)**2).quo(n1 - 1) + ((s2 ** 2/n2)**2).quo(n2 - 1))
    t_value   = (data1.mean - data2.mean).quo(std_error)
    t         = TestStatisticHelper::initialize_with({ :distribution       => :t,
                                                       :value              => t_value,
                                                       :degrees_of_freedom => nu })
    if t.p < significance then reject_left = true;
    elsif (1-t.p) < significance then reject_right = true; end

    { :significance_level => significance,
      :left_tail          => { :h0 => h0, :h1 => h1_left, :p => t.p, :reject => reject_left},
      :right_tail         => { :h0 => h0, :h1 => h1_right, :p => 1-t.p, :reject => reject_right}
    }
  end

  def test_proportion(data1,data2,significance)
    h0        = 'p1 = p2'
    h1_left   = 'p1 < p2'
    h1_right  = 'p1 > p2'
    p_hat_1   = data1.count(1).quo(n1 = data1.size()).to_f 
    p_hat_2   = data2.count(1).quo(n2 = data2.size()).to_f
    p_pooled  = (data1.count(1)+data2.count(1)).quo(n1 + n2)
    std_error = Math.sqrt( p_pooled*( 1 - p_pooled)*(1.quo(n1)+1.quo(n2)) )
    z_value   = (p_hat_1 - p_hat_2).quo(std_error)
    z         = TestStatisticHelper::initialize_with({ :distribution => :z,
                                                       :value        => z_value })
    puts "phat1 - phat2 = #{p_hat_1 - p_hat_2}"
    puts "z = #{z}"
    if (1 - z.p) < significance then reject_left = true;
    elsif z.p < significance then reject_right = true; end

    { :significance_level => significance,
      :left_tail          => { :h0 => h0, :h1 => h1_left, :p => 1-z.p, :reject => reject_left },
      :right_tail         => { :h0 => h0, :h1 => h1_right, :p => z.p, :reject => reject_right }
    }
  end
end