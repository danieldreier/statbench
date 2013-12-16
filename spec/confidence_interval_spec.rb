require_relative 'spec_helper'

describe ConfidenceInterval do 
  describe 'mean intervals' do 
    it 'gives interval estimate of difference between two means' do 
      processor = DataAnalyst.new(DATASET_1,DATASET_2)
      expect(processor.mean_difference).to 
        eql({ :interval => [-3,00521, 1.78591], :confidence => 0.95})
    end
  end # 'mean intervals'

  describe 'variability intervals' do 
    it 'gives interval estimate of difference between two standard deviations' do 
      processor = DataAnalyst.new(DATASET_1,DATASET_2)
      expect(processor.sdev_difference).to eql()
    end
  end # 'variability intervals'
end # describe ConfidenceInterval