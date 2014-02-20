require_relative 'spec_helper'

describe Troubleshooter do 
  before(:all) do 
    @processor = Troubleshooter.new(DATA_FILE_1,DATA_FILE_2)
  end

  it "can run without fucking up" do 
    expect(@processor.data1.class).to eql(Array)
  end
end