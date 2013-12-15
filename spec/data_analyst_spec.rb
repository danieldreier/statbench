require_relative 'spec_helper'
require_relative '../lib/data_analyst.rb'

describe DataAnalyst do 
  it 'gets statistics from data sets' do 
    processor = DataAnalyst.new(DATASET_1,DATASET_2)
    expected_result = { 'nu1' => 199, 'mean1' => 28.6537, 'var1' => 279.2421,
                        'nu2' => 199, 'mean2' => 29.2633, 'var2' => 314.6817 }
    expect(processor.process).to eql(expected_result)
  end

  it 'initializes with a processed hash' do 
    processor = DataAnalyst.new(DATASET_1,DATASET_2)
    expect(processor.hash).to eql( { 'nu1' => 199, 'mean1' => 28.6537, 'var1' => 279.2421,
                                     'nu2' => 199, 'mean2' => 29.2633, 'var2' => 314.6817 })
  end
end