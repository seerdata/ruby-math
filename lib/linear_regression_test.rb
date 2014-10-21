require_relative './linear_regression'

data1 = [0.0,1.0,2.0,3.0,4.0,5.0,6.0]
data2 = [0.0,3.0,6.0,9.0,12.0,15.0,18.0]
data3 = [0.0,5.0,10.0,15.0,20.0,25.0,30.0]

lreg = LinearRegression.new(data1)
print 'slope = ', lreg.slope; puts
print 'trend = ', lreg.trend; puts
print 'predict = ', lreg.predict(8); puts
puts; puts
lreg = LinearRegression.new(data2)
print 'slope = ', lreg.slope; puts
print 'trend = ', lreg.trend; puts
print 'predict = ', lreg.predict(8); puts
puts; puts
lreg = LinearRegression.new(data3)
print 'slope = ', lreg.slope; puts
print 'trend = ', lreg.trend; puts
print 'predict = ', lreg.predict(8); puts
