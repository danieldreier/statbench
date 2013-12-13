require_relative 'spec_helper'

describe ConfidenceInterval do 
  describe 'mean intervals' do 
    it 'estimates a difference between two means' do 
      processor = DataAnalyst.new(DATASET_1,DATASET_2)
      expect(processor.mean_difference).to be_within(0.005).of(-0.6096)
    end
  end # 'mean intervals'

  describe 'variability intervals' do 
    it 'estimates a difference between two standard deviations' do 
      processor = DataAnalyst.new(DATASET_1,DATASET_2)
      expect(processor.sdev_difference).to be_within(0.005).of(-1.0287)
    end
  end # 'variability intervals'
end