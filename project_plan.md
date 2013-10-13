Statbench Project Plan
======================

Minimum viable functionality
----------------------------

- Runs on command line
- Accepts one value per line data files
- Outputs summary statistics
- rspec tests
- All gems specified via bundler Gemfile

# Basic architecture

model: calculator class
view: cli class
controller: controller class

## calculator class

- summary_stats(array)
    returns hash of:
      - 1st and 3rd quartile
      - median
      - minimum and maximum values
      - IQR
      - upper and lower fence

## controller class:

- read_datafile(filename)
- summary_stats_from_file(filename)

## cli class:

Can:
- --help
- --summary-stats -s
- --file filename

some kind of output class to print results

# Rspec tests needed

### calculator class:
summary_stats:
  - Pass in an array of numbers
  - Expect a hash of summary statistics of known values

### controller class:

read_datafile(filename):
  - pass in a filename
  - use mocks to expect it to read that file
  - expect it to return an array of values

- summary_stats_from_file(filename)
  - pass in a filename
  - use mocks to expect it to read that file
  - expect it to return a bash of summary stats