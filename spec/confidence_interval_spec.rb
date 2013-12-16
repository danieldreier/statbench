require_relative 'spec_helper'

describe ConfidenceInterval do 
  before(:all) do 
    @processor = DataAnalyst.new(DATASET_1,DATASET_2)
  end

  describe 'mean intervals' do 
    it 'gives interval estimate of difference between two means' do 
      expect(@processor.mean_difference).to eql({ :interval => [-3.00515, 1.78595], :confidence => 0.95})
    end

    it 'uses 95% confidence level by default' do 
      expect(@processor.mean_difference).to eql(@processor.mean_difference(0.95))
    end

    it 'allows user to specify confidence level' do 
      expect(@processor.mean_difference(0.99)).to eql({ :interval => [ -3.76344, 2.54424 ], :confidence => 0.99})
    end
  end # 'mean intervals'

  describe 'variability intervals' do 
    it 'gives interval estimate of difference between two standard deviations' do 
      expect(@processor.sdev_difference).to eql({ :interval => [0.81951, 1.0829], :confidence => 0.95 })
    end

    it 'uses 95% confidence level by default' do 
      expect(@processor.sdev_difference).to eql(@processor.sdev_difference(0.95))
    end

    it 'allows user to specify confidence level' do 
      expect(@processor.sdev_difference(@processor.hash, 0.99)).to eql( { :interval => [ 0.78421, 1.13158 ], :confidence => 0.99 })
    end
  end # 'variability intervals'
end # describe ConfidenceInterval