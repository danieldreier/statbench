require_relative 'spec_helper'

describe HypothesisTest do 
  include HypothesisTest
  describe 'test results' do 
    describe '::mean_test_results' do 
      it 'gives significance level and outcome' do 
        processor = DataAnalyst.new(DATASET_1,DATASET_2)
        expect(processor.mean_test_results).to eql({ :summary    => "mean response time hasn't changed", 
                                                     :confidence => 0.95})
      end
    end

    describe '::variance_test_results' do 
      it 'gives significance level and outcome' do 
        processor = DataAnalyst.new(DATASET_1,DATASET_2)
        expect(processor.variance_test_results).to eql({ :summary    => "variability in response time hasn't changed", 
                                                         :confidence => 0.95 })
      end
    end
  end # 'test results'

  describe 'testing two means' do 
    describe '::faster?' do 
      it 'returns false when response times unequal' do 
        processor = DataAnalyst.new(DATASET_1,DATASET_3)
        expect(processor.faster?).to be_false
      end

      it 'returns true when response times are equal' do 
        processor = DataAnalyst.new(DATASET_1,DATASET_1)
        expect(processor.faster?).to be_true
      end

      it 'uses user-specified significance level' do 
        processor = DataAnalyst.new(DATASET_4,DATASET_5)
        expect(processor.faster?(processor.hash,0.001)).to be_true
        expect(processor.faster?(processor.hash,0.05)).to be_false
      end

      it 'uses the 0.05 significance level by default' do 
        processor = DataAnalyst.new(DATASET_4,DATASET_5)
        expect(processor.faster?(processor.hash,0.05)).to eql(processor.faster?)
      end
    end # '::faster?'

    describe '#mean_hypothesis_test' do 
      it 'returns false when response times equal' do 
        processor = DataAnalyst.new(DATASET_1,DATASET_1)
        expect(processor.mean_hypothesis_test).to be_false
      end

      it 'returns true when response times unequal' do 
        processor = DataAnalyst.new(DATASET_1,DATASET_3)
        expect(processor.mean_hypothesis_test).to be_true
      end
    end
  end # 'testing two means'

  describe 'testing two variances' do 
    describe '::more_consistent?' do 
      it 'returns false when variability is unequal' do 
        processor = DataAnalyst.new(DATASET_1,DATASET_3)
        expect(processor.more_consistent?).to be_false
      end

      it 'returns true when variability is equal' do 
        processor = DataAnalyst.new(DATASET_1,DATASET_1) 
        expect(processor.more_consistent?).to be_true
      end

      it 'allows user to choose significance level' do 
        processor = DataAnalyst.new(DATASET_2,DATASET_1)
        expect(processor.more_consistent?(processor.hash,0.001)).to be_true
        expect(processor.more_consistent?(processor.hash,0.5)).to be_false
      end

      it 'uses the 0.05 significance level by default' do 
        processor = DataAnalyst.new(DATASET_4,DATASET_5)
        expect(processor.more_consistent?(processor.hash,0.05)).to eql(processor.equal_variability?)
      end
    end # '::more_consistent?'
  end # 'testing two variances'
end # 'describe HypothesisTest'