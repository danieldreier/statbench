require_relative 'spec_helper'

describe HypothesisTest do 
  include HypothesisTest

  describe 'testing two means' do 
    describe '::faster?' do 
      it 'returns be_true when new response time is faster' do 
        processor = DataAnalyst.new(DATA_FILE_1,DATA_FILE_3)
        expect(processor.faster?).to be_true
      end

      it 'returns false when response times are equal' do 
        processor = DataAnalyst.new(DATA_FILE_1,DATA_FILE_1)
        expect(processor.faster?).to be_false
      end

      it 'returns false when new response time is slower' do 
        processor = DataAnalyst.new(DATA_FILE_3,DATA_FILE_1)
        expect(processor.faster?).to be_false
      end

      it 'uses user-specified significance level' do 
        processor = DataAnalyst.new(DATA_FILE_4,DATA_FILE_5)
        expect(processor.faster?(processor.hash,0.001)).to be_false
        expect(processor.faster?(processor.hash,0.05)).to be_true
      end

      it 'uses the 0.05 significance level by default' do 
        processor = DataAnalyst.new(DATA_FILE_4,DATA_FILE_5)
        expect(processor.faster?(processor.hash,0.05)).to eql(processor.faster?)
      end
    end # '::faster?'
  end # 'testing two means'

  describe 'testing two variances' do 
    describe '::more_consistent?' do 
      it 'returns true when new variability is lower' do 
        processor = DataAnalyst.new(DATA_FILE_1,DATA_FILE_3)
        expect(processor.more_consistent?(processor.hash,0.05)).to be_true
      end

      it 'returns false when variability is equal' do 
        processor = DataAnalyst.new(DATA_FILE_1,DATA_FILE_1) 
        expect(processor.more_consistent?(processor.hash,0.05)).to be_false
      end

      it 'returns false when new variability is higher' do 
        processor = DataAnalyst.new(DATA_FILE_3,DATA_FILE_1)
        expect(processor.more_consistent?(processor.hash,0.05)).to be_false
      end

      it 'allows user to choose significance level' do 
        processor = DataAnalyst.new(DATA_FILE_2,DATA_FILE_1)
        expect(processor.more_consistent?(processor.hash,0.001)).to be_false
        expect(processor.more_consistent?(processor.hash,0.5)).to be_true
      end

      it 'uses the 0.05 significance level by default' do 
        processor = DataAnalyst.new(DATA_FILE_4,DATA_FILE_5)
        expect(processor.more_consistent?(processor.hash,0.05)).to eql(processor.more_consistent?)
      end
    end # '::more_consistent?'
  end # 'testing two variances'
end # 'describe HypothesisTest'