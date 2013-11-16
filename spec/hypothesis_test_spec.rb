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

    it 'adjusts results according to significance level' do 
      result1 = HypothesisTest::test({ :dataset_1    => SMALL_DATASET_3,
                                       :dataset_2    => SMALL_DATASET_6 })
      result2 = HypothesisTest::test({ :dataset_1    => SMALL_DATASET_3,
                                       :dataset_2    => SMALL_DATASET_6,
                                       :significance => 0.01 })
      result1[:left_tail][:reject].should eql(true)
      result2[:left_tail][:reject].should eql(false || nil)
    end

    it 'conducts a set of tests for two means with one h0 rejected' do 
      result = HypothesisTest::test({ :dataset_1 => SMALL_DATASET_3,
                                      :dataset_2 => SMALL_DATASET_6 })
      result[:left_tail][:h1].should be('mu1 < mu2')
      result[:left_tail][:reject].should eql(true)
      result[:right_tail][:h1].should be('mu1 > mu2')
      result[:right_tail][:reject].should eql(false || nil)
    end

    it 'conducts a set of tests for two means with h0 not rejected' do
      result = HypothesisTest::test({ :dataset_1 => SMALL_DATASET_1,
                                      :dataset_2 => SMALL_DATASET_5 })
      result[:left_tail][:reject].should eql(false || nil)
      result[:left_tail][:reject].should eql(false || nil)
    end

    it 'conducts a set of tests for two proportions with one h0 rejected' do
      result = HypothesisTest::test({ :dataset_1 => LARGE_BINOMIAL_DATASET_1,
                                      :dataset_2 => LARGE_BINOMIAL_DATASET_2,
                                      :parameter => :proportion })
      result[:left_tail][:h1].should be('p1 < p2')
      result[:left_tail][:reject].should eql(false || nil)
      result[:right_tail][:h1].should be('p1 > p2')
      result[:right_tail][:reject].should eql(true)
    end

    it 'conducts a set of tests for two proportions with h0 not rejected' do 
      result = HypothesisTest::test({ :dataset_1    => SMALL_BINOMIAL_DATASET_1,
                                      :dataset_2    => SMALL_BINOMIAL_DATASET_3,
                                      :parameter    => :proportion,
                                      :significance => 0.1 })
      result[:left_tail][:reject].should eql(false || nil)
      result[:right_tail][:reject].should eql(false || nil)
    end

    it 'conducts a set of tests for two variances with one h0 rejected' do 
      result = HypothesisTest::test({ :dataset_1    => SMALL_DATASET_3,
                                      :dataset_2    => SMALL_DATASET_1,
                                      :parameter    => :variance,
                                      :significance => 0.05 })
      result[:left_tail][:reject].should eql(true)
      result[:right_tail][:reject].should eql(false)
    end

    it 'conducts a set of tests for two variances with h0 not rejected' do 
      result = HypothesisTest::test({ :dataset_1    => SMALL_DATASET_3,
                                      :dataset_2    => SMALL_DATASET_2,
                                      :parameter    => :variance,
                                      :significance => 0.05 })
      result[:left_tail][:reject].should eql(false || nil)
      result[:right_tail][:reject].should eql(false || nil)
    end

    it 'uses variance test when standard deviation specified' do 
      result1 = HypothesisTest::test({ :dataset_1    => SMALL_DATASET_3,
                                       :dataset_2    => SMALL_DATASET_2,
                                       :parameter    => :variance,
                                       :significance => 0.05 })
      result2 = HypothesisTest::test({ :dataset_1    => SMALL_DATASET_3,
                                       :dataset_2    => SMALL_DATASET_2,
                                       :parameter    => :sdev,
                                       :significance => 0.05 })
      result1[:parameter].should be(:variance)
      result2[:parameter].should be(:sdev)
      result1[:left_tail].should eql(result2[:left_tail])
      result1[:right_tail].should eql(result2[:right_tail])
    end
  end
end