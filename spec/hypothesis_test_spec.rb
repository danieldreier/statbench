require_relative 'spec_helper'

describe HypothesisTest do 
  include HypothesisTest
  describe 'test results' do 
    describe '#mean_test_results' do 
      it 'gives significance level and outcome' do 
        processor = DataAnalyst.new(DATASET_1,DATASET_2)
        expect(processor.mean_test_results).to eql({ :equal_mean? => true, :significance => 0.05})
      end
    end

    describe '#variance_test_results' do 
      it 'gives significance level and outcome' do 
        processor = DataAnalyst.new(DATASET_1,DATASET_2)
        expect(processor.variance_test_results).to eql({ :equal_variance? => true, :significance => 0.05 })
      end
    end
  end # 'test results'

  describe 'testing two means' do 
    describe '#equal_response_time?' do 
      it 'returns false when response times unequal' do 
        processor = DataAnalyst.new(DATASET_1,DATASET_3)
        expect(processor.equal_response_time?).to be_false
      end

      it 'returns true when response times are equal' do 
        processor = DataAnalyst.new(DATASET_1,DATASET_1)
        expect(processor.equal_response_time?).to be_true
      end

      it 'allows user to choose a significance level' do 
        processor = DataAnalyst.new(DATASET_4,DATASET_5)
        expect(processor.equal_response_time?(0.001)).to be_true
        expect(processor.equal_response_time?(0.05)).to be_false
      end

      it 'uses the 0.05 significance level by default' do 
        processor = DataAnalyst.new(DATASET_4,DATASET_5)
        expect(processor.equal_response_time?(0.05)).to eql(processor.equal_response_time?)
      end
    end # '#equal_response_time?'
  end # 'testing two means'

  describe 'testing two variances' do 
    describe '#equal_variability?' do 
      it 'returns false when variability is unequal' do 
        processor = DataAnalyst.new(DATASET_1,DATASET_3)
        expect(processor.equal_variability?).to be_false
      end

      it 'returns true when variability is equal' do 
        processor = DataAnalyst.new(DATASET_1,DATASET_1) 
        expect(processor.equal_variability?).to be_true
      end

      it 'allows user to choose significance level' do 
        processor = DataAnalyst.new(DATASET_4,DATASET_5)
        expect(processor.equal_variability?(0.001)).to be_true
        expect(processor.equal_variability?(0.3)).to be_false
      end

      it 'uses the 0.05 significance level by default' do 
        processor = DataAnalyst.new(DATASET_4,DATASET_5)
        expect(processor.equal_variability?(0.05)).to eql(processor.equal_variability?)
      end
    end # '#equal_variability?'
  end # 'testing two variances'
end # 'describe HypothesisTest'