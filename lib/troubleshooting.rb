require 'statsample'
require_relative 'confidence_interval'
require_relative 'hypothesis_test'

class Troubleshooter
  include Statsample
  include ConfidenceInterval
  include HypothesisTest

  attr_reader :data1
  attr_reader :data2

  def initialize(data1,data2)
    # assume data sets are definitely strings for now
    @data1 = Array.new; @data2 = Array.new
    File.open(data1,'r+') { |file| file.each_line { |line| @data1 << line.chomp } }
    File.open(data2,'r+') { |file| file.each_line { |line|@data2 << line.chomp } }
  end
end