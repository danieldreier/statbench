Given(/^two data sets$/) do
  @data1 = "#{ENV['PWD']}/spec/test_data/data1.txt"
  @data2 = "#{ENV['PWD']}/spec/test_data/data2.txt"
end

When(/^I request a comparison$/) do
  `bundle exec bin/statbench --old #{@data1} --new #{@data2} compare`
end