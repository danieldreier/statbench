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

  it 'returns summary statistics' do 
    expect(@processor.summary_stats).to eql( {:old_config=> { :min=>0.34, 
                                                            :max=>58.71, 
                                                            :median=>29.355, 
                                                            :iqr=>42.8, 
                                                            :upper_fence=>78.965, 
                                                            :lower_fence=>-34.845 
                                                          }, 
                                            :new_config=> { :min=>0.01, 
                                                            :max=>59.98, 
                                                            :median=>29.515, 
                                                            :iqr=>44.78, 
                                                            :upper_fence=>82.86, 
                                                            :lower_fence=>-37.655
                                                          }
                                            })
  end
end