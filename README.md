Statistically Informed Benchmarking Tool
=========

DO NOT USE THIS PROJECT
-----------------------
I'm just starting to write this - I'm an inexperienced developer and even worse statistician. This will be little more than a wrapper for the statsample gem if we do it right.

Motivation
----------

I'm frustrated by the misleading summary statistics provided by AB and Siege. Blitz.io and others provide beautiful graphs that lack information about statistical significance.

Consequently, I'm setting out to write a tool that performs the basic statistical analysis that I learned in first year undergrad statistics. I am NOT a very good statistician, so take this all with a grain of salt.

Goal
----

Perform benchmarks of web pages that take advantage of basic statistical techniques to reduce cognitive bias and facilitate automated optimization

# Input
- long list of numbers
- Several labeled long lists of numbers for comparison

# Output
- How large does the sample need to be for 95% CI
- Validate assumption of standard normal distribution of data
- Histogram
- Descriptive statistics
- Boxplot

## Sample scenario ##
I feed in two sets of performance data from Apache, AB, raw Siege logs, etc parsed into a CSV of load times. Statbench tells me whether my sample size is big enough at a given confidence level and "resolution" of difference (say, the ability to detect a 0.25 second difference in averages), then performs a hypothesis test to determine whether the two sets are different. If they are different, it reports the range within which we can have a 95% level of confidence that one is faster than the other. For example, it may say that we can be 95% confident that sample A is -0.1 to 1.3 seconds faster than sample B.

## Desired output ##

```bash
$ statbench --validate --confidence=95 --normality-test sample_a.csv sample_b.csv
sample_a.csv: normally distributed @ 95% confidence
[Warning] sample_a.csv: NOT normally distributed @ 95% confidence

$ statbench --validate --confidence=95 --sample-size --resolution=0.25 sample_a.csv sample_b.csv
[Warning] Insufficient sample size: collect at least 53,500 samples for each data series

$ statbench --compare --boxplot --ascii sample_a.csv sample_b.csv 
Test A       -----------========O========--------------
Test B                  --------========O=========--------------
Test C                          -------------====O=====--------------->
          |    |    |    |    |    |    |    |    |    |    |    |    |
         0.2  0.3  0.4  0.5  0.6  0.7  0.8  0.9  1.0  1.1  1.2  1.3  1.4

```


## References

Short, simple, direct scripts for creating ASCII graphical histograms in the terminal.
https://github.com/philovivero/distribution

Text::BoxPlot - Render ASCII box and whisker charts
https://metacpan.org/source/DAGOLDEN/Text-BoxPlot-0.001/README

Statsample Ruby Gem
http://ruby-statsample.rubyforge.org/
