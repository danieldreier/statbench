Given(/^two data files$/) do
  @data1 = "#{ENV['PWD']}/spec/test_data/data1.txt"
  @data2 = "#{ENV['PWD']}/spec/test_data/data2.txt"
end

When(/^I request a comparison$/) do
  `bundle exec bin/statbench --old #{@data1} --new #{@data2} compare`
end

Then(/^I should be told which configuration is faster$/) do
  puts "Average response time hasn't changed."
end

Then(/^I should be told which configuration is more consistent$/) do
  puts "Variability in response times hasn't changed."
end