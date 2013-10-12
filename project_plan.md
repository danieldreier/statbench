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

## controller class:

- read_datafile(filename)
- summary_stats_from_file(filename)

## cli class:

Can:
- --help
- --summary-stats -s
- --file filename

