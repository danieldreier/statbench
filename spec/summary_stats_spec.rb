require_relative 'spec_helper'

describe SummaryStats do 
  include SummaryStats
  before(:each) do 
    @processor = DataAnalyst.new(DATA_FILE_1,DATA_FILE_2)
  end

  describe '::summary_statistics' do 
    describe 'single data set' do 
      it 'returns a hash of values'
      it 'includes minimum, maximum, median, Q1, Q2, IQR, upper fence, and lower fence'
    end
    describe 'two data sets'
  end
end # SummaryStats