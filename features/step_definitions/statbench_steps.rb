Given(/^two data sets$/) do
  @data1 = "#{DATA_PATH = File.expand_path('../../../spec/test_data',__FILE__)}/data1.txt"
  @data2 = "#{DATA_PATH}/data2.txt"
end

When(/^I request a comparison$/) do
  `bundle exec bin/statbench --old #{@data1} --new #{@data2} compare`
end