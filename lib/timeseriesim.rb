require_relative './linear_regression'

class Array; def in_groups(num_groups)
  return [] if num_groups == 0
  slice_size = (self.size/Float(num_groups)).ceil
  self.each_slice(slice_size).to_a
end; end

class TimeSeriesim

  def get_n_values(n,start_slope)
    ary = []
    for i in 0..n
      i = i.to_f + start_slope
      value = i + rand
      ary.push(value)
    end
    ary
  end

  def get_trend_value(data)
    lreg = LinearRegression.new(data)
    #print 'slope = ', lreg.slope; puts
    #print 'trend = ', lreg.trend; puts
    #print 'predict = ', lreg.predict(n + 1); puts
    lreg.trend[-1]
  end

  def get_predict_value(data)
    lreg = LinearRegression.new(data)
    #print 'slope = ', lreg.slope; puts
    #print 'trend = ', lreg.trend; puts
    #print 'predict = ', lreg.predict(n + 1); puts
    print 'predict value = ', lreg.predict(data.size + 1); puts
  end

  def get_slope(data)
    lreg = LinearRegression.new(data)
    print 'slope = ', lreg.slope; puts
  end

  def get_one_noisy_value(n,start_slope,noise)
    ary1 = get_n_values(n,start_slope)
    print ary1; puts
    get_slope(ary1)
    get_predict_value(ary1)
    puts; puts
    # put noisy value in the middle
    # index = n / 2
    # print 'index = ', index
    # slice and send data off so you can get noisy point
    aryhalf = ary1.in_groups(2)
    aryhalf1 = aryhalf[0]
    aryhalf2 = aryhalf[1]
    predict_value = get_trend_value(aryhalf1)
    print 'predict value = ', predict_value; puts
    predict_value = predict_value + noise
    print 'predict value = ', predict_value; puts
    ary3 = aryhalf1.concat([predict_value]).concat(aryhalf2)
    print ary3; puts; puts
    get_slope(ary3)
    get_predict_value(ary3)
  end

#
# => This calls get_n_values with one noisy point in the middle
#

  def get_n_values_with_noise(n,start_slope)
    ary1 = get_n_values(n,start_slope)
    # put noisy value in the middle
    index = n / 2
    print 'index = ', index
  end

end


tss = TimeSeriesim.new
ary = tss.get_one_noisy_value(10,1.0,10003.1)

=begin
x = [0,1,2,3,4,5,6,7,8,9]
y = x.in_groups(2)
print y[0]; puts
=end
