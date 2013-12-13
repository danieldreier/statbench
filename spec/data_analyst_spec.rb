require_relative 'spec_helper'
require_relative '../lib/data_analyst.rb'

describe DataAnalyst do 
  describe 'mean methods' do
    it 'calculates difference between two means' do 
      processor = DataAnalyst.new(DATASET_1,DATASET_2)
      expect(processor.mean_difference).to be_within(0.005).of(-0.6096)
    end
  end # 'mean methods'

  describe 'variability methods' do 
    describe '.equal_variability?' do 
      it 'returns false when variability is not equal' do 
        processor = DataAnalyst.new(DATASET_1,DATASET_3)
        expect(processor.equal_variability?).to be_false
      end

      it 'returns true when variability is equal' do 
        processor = DataAnalyst.new(DATASET_1,DATASET_1)
        expect(processor.equal_variability?).to be_true
      end
    end # '.equal_variability?'

    it 'calculates the difference between two standard deviations' do 
      processor = DataAnalyst.new(DATASET_1,DATASET_2)
      expect(processor.sdev_difference).to be_within(0.005).of(-1.0287)
    end
  end # 'variability methods'
end