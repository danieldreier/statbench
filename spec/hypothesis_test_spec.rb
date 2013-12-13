require_relative 'spec_helper'

describe HypothesisTest do 
  include HypothesisTest
  describe 'testing two means' do 
    describe '#equal_response_time?' do 
      it 'returns false when response times unequal' do 
        processor = DataAnalyst.new(DATASET_1,DATASET_2)
        expect(processor.equal_response_time?).to be_false
      end

      it 'returns true when response times are equal' do 
        processor = DataAnalyst.new(DATASET_1,DATASET_1)
        expect(processor.equal_response_time?).to be_true
      end
    end # '#equal_response_time?'
  end # 'testing two means'
end # 'describe HypothesisTest'