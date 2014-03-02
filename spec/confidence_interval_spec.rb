require_relative 'spec_helper'

describe ConfidenceInterval do 
  before(:all) do 
    @file_processor = DataAnalyst.new(DATA_FILE_1,DATA_FILE_2)
  end

  describe 'mean intervals' do 
    it 'gives interval estimate of difference between two means' do 
      expect(@file_processor.mean_difference).to eql({ :interval => [-3.00515, 1.78595], :confidence => 0.95})
    end

    it 'uses 95% confidence level by default' do 
      expect(@file_processor.mean_difference).to eql(@file_processor.mean_difference(@file_processor.hash,0.95))
    end

    it 'allows user to specify confidence level' do 
      expect(@file_processor.mean_difference(@file_processor.hash,0.99)).to eql({ :interval => [ -3.76344, 2.54424 ], 
                                                                        :confidence => 0.99})
    end
  end # 'mean intervals'

  describe 'variability intervals' do 
    it 'gives interval estimate of difference between two standard deviations' do 
      expect(@file_processor.sdev_difference).to eql({ :interval => [0.81951, 1.0829], :confidence => 0.95 })
    end

    it 'uses 95% confidence level by default' do 
      expect(@file_processor.sdev_difference).to eql(@file_processor.sdev_difference(@file_processor.hash,0.95))
    end

    it 'allows user to specify confidence level' do 
      expect(@file_processor.sdev_difference(@file_processor.hash, 0.99)).to eql( { :interval => [ 0.78421, 1.13158 ], :confidence => 0.99 })
    end
  end # 'variability intervals'
end # describe ConfidenceInterval