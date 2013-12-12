require_relative 'spec_helper'
require_relative '../lib/data_analyst.rb'

describe DataAnalyst do 
  describe 'arguments' do 
    it 'turns array into a vector' do 
      processor = DataAnalyst.new([1,2,3])
      processor.data.class.should eql(Statsample::Vector)
    end
  end
end