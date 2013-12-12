require_relative 'spec_helper'
require_relative '../lib/data_analyst.rb'

describe DataAnalyst do 
  describe 'arguments' do 
    it 'takes an array as an argument' do 
      processor = DataAnalyst.new([1,2,3])
      processor.array.should eql([1,2,3])
    end
  end
end