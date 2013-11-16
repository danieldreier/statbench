require 'spec_helper'
require_relative '../test/data'

module HypothesisTest
  describe HypothesisTest do 
    it 'returns results as a hash with keys :left_tail, :right_tail, and
    :significance_level' do 
      results = HypothesisTest::test({ :dataset_1 => SMALL_DATASET_1,
                                       :dataset_2 => SMALL_DATASET_2 })
      results.should be_an_instance_of(Hash)
      results.should have_key[:left_tail]
      results.should have_key[:right_tail]
      results.should have_key[:significance_level]
    end

    it 'conducts tests for mean by default' do 
      results = HypothesisTest::test({ :dataset_1 => SMALL_DATASET_1,
                                       :dataset_2 => SMALL_DATASET_2 })
      results[:left_tail][:h0].should be('mu1 = mu2')
    end

    it 'performs two one-tailed tests by default' do 
      results = HypothesisTest::test({ :dataset_1 => SMALL_DATASET_1,
                                       :dataset_2 => SMALL_DATASET_2 })
      results[:left_tail][:h1].should be('mu1 < mu2')
      results[:right_tail][:h1].should be('mu1 > mu2')
    end

    it 'returns h0, h1, p, and result for each test' do 
      results = HypothesisTest::test({ :dataset_1 => SMALL_DATASET_1,
                                       :dataset_2 => SMALL_DATASET_2 })
      # This will be a great candidate for refactoring!
      results[:left_tail].should have_key(:h0)
      results[:left_tail].should have_key(:h1)
      results[:left_tail].should have_key(:p)
      results[:left_tail].should have_key(:reject)
      results[:right_tail].should have_key(:h0)
      results[:right_tail].should have_key(:h1)
      results[:right_tail].should have_key(:p)
      results[:right_tail].should have_key(:reject)     
    end
    
  	it 'establishes a 0.05 significance level by default' do 
  		result = HypothesisTest::test({ :dataset_1 => SMALL_DATASET_1,
                                      :dataset_2 => SMALL_DATASET_2 })
      result[:significance_level].should == 0.05
  	end

    it 'conducts a set of tests for two means with one h0 rejected' do 
      specify do 
        pending
      end
    end

    it 'conducts a set of tests for two means with h0 not rejected' do
      specify do 
        pending
      end
    end

    it 'conducts a set of tests for two proportions with one h0 rejected' do
      specify do 
        pending
      end
    end

    it 'conducts a set of tests for two proportions with h0 not rejected' do 
      specify do 
        pending
      end
    end

    it 'conducts a set of tests for two variances with one h0 rejected' do 
      specify do 
        pending
      end
    end

    it 'conducts a set of tests for two variances with h0 not rejected' do 
      specify do 
        pending
      end
    end

    
    # Needed hypothesis tests:
    #
    # => Single mean
    # => - Left-tailed
    # => - Right-tailed
    #
    # => Two mean
    # => - Two-tailed
    # => - Left-tailed
    # => - Right-tailed
    #
    # => Single proportion
    # => - Two-tailed
    # => - Left-tailed
    # => - Right-tailed
    #
    # => Two proportion
    # => - Two-tailed
    # => - Left-tailed
    # => - Right-tailed
    # 
    # => One sdev/variance
    # => - Two-tailed
    # => - Left-tailed
    # => - Right-tailed
    #
    # => Two sdev/variance
    # => - Two-tailed
    # => - Left-tailed
    # => - Right-tailed
    #
    # => Goodness of fit (separate module?)
  end
end