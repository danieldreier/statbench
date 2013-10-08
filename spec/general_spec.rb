require 'spec_helper'

module Statbench
  describe "statistical capabilities" do
    it "can calculate percentiles"
    it "can find sample minimum"
    it "can find sample maximum"
  end

  describe "guidance provided" do
    it "can recommend a sample size, given initial data, for 90% confidence in
        detecting differences of 0.25 seconds in average load time"
    it "can recommend an appropriate target confidence level given an expected 
        number of repeated tests"
    it "can display a recommended procedure for collecting good data (text)"
  end

  describe "comparison capabilities" do
    it "can compare two datasets and report that one is between x and y seconds 
        faster than the other to 90% confidence"
    it "can calculate goodness of fit to verify that data can be processed 
        using assumption of a standard normal distribution."
    it "can determine whether differences in variability in two sample sets are
        statistically significant to 90% confidence"
    it "can apply a Mann-Whitney-U test (http://en.wikipedia.org/wiki/Mann%E2%80%93Whitney_U) to
        compare two data sets against the null hypothesis that they are the same"
    it "can compare distribution of load times from apache logs against distribution in 
        benchmark test to validate sampling procedure - sample should follow similar distribution
        when normalized"
  end

  describe "input options" do
    it "can accept CSV formatted data series"
    it "can accept one-value-per-line text files"
  end

  describe "reporting" do
    it "can produce a histogram of a dataset"
    it "can produce box plots to compare multiple datasets"
    it "can report the results of comparison tests"

  end

end