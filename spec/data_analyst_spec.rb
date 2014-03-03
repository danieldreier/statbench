require_relative 'spec_helper'

describe DataAnalyst do 

  before(:each) do 
    @processor = DataAnalyst.new(DATA_FILE_1,DATA_FILE_2)
  end

  it 'gets statistics from data files' do 
    expected_result = { 'nu1' => 199, 'mean1' => 28.6537, 'var1' => 279.2421,
                        'nu2' => 199, 'mean2' => 29.2633, 'var2' => 314.6817 }
    expect(@processor.process_data).to eql(expected_result)
  end

  it 'initializes with a processed hash' do 
    expect(@processor.hash).to eql( { 'nu1' => 199, 'mean1' => 28.6537, 'var1' => 279.2421,
                                     'nu2' => 199, 'mean2' => 29.2633, 'var2' => 314.6817 })
  end

  it 'returns summary of a hypothesis test' do 
    expect(@processor.mean_test_summary).to eql("Average response time hasn't changed.")
  end

  it 'returns an estimated difference' do 
    outcome = "Average response time may have improved by as much as 3.00515 seconds or gone up by as much as 1.78595 seconds."
    expect(@processor.estimate_difference_mean).to eql(outcome)
  end
end
