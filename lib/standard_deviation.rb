#
# matches up with google spreadsheets =stdev(a3:a8)
#

require 'descriptive-statistics'
require 'ruby-standard-deviation'

data0 = [1,1,2,3,10]

stats = DescriptiveStatistics::Stats.new(data0)
variance = stats.variance
sd = stats.standard_deviation
stats.relative_standard_deviation

print 'standard_deviation = ', sd; puts
print 'standard_deviation = ', data0.stdev
puts; puts

data1 = [1,3,21,32,42]
stats = DescriptiveStatistics::Stats.new(data1)

print 'standard_deviation = ', stats.standard_deviation; puts
print 'standard_deviation = ', data1.stdev

puts; puts

data1 = [4,5,5,4,4,2,2,6]
stats = DescriptiveStatistics::Stats.new(data1)

print 'standard_deviation = ', stats.standard_deviation; puts
print 'standard_deviation = ', data1.stdev

puts; puts

# calculate population standard deviation
p data1.stdevp
