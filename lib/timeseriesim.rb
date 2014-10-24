require_relative './linear_regression'

class Array
  def in_groups(num_groups)
    return [] if num_groups == 0
    slice_size = (self.size/Float(num_groups)).ceil
    self.each_slice(slice_size).to_a
  end
end

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
    lreg.trend[-1]
  end

  def get_predict_value(data)
    lreg = LinearRegression.new(data)
    lreg.predict(data.size + 1)
  end

  def get_slope(data)
    lreg = LinearRegression.new(data)
    lreg.slope
  end

  def get_one_noisy_value(n,start_slope,noise)
    ary1 = get_n_values(n,start_slope)
    #print ary1; puts
    #print 'slope = ', get_slope(ary1); puts
    #print 'predict value = ', get_predict_value(ary1); puts; puts
    aryhalf = ary1.in_groups(2)
    aryhalf1 = aryhalf[0]
    aryhalf2 = aryhalf[1]
    trend_value = get_trend_value(aryhalf1)
    noisy_value = trend_value + noise
    #print 'introduce noisy value = ', noisy_value; puts; puts
    ary3 = aryhalf1.concat([noisy_value]).concat(aryhalf2)
  end
end

=begin
tss = TimeSeriesim.new
ary = tss.get_one_noisy_value(10,1.0,10003.1)
print ary; puts; puts
print 'slope = ', tss.get_slope(ary); puts
print 'predict = ', tss.get_predict_value(ary); puts
=end

=begin
x = [0,1,2,3,4,5,6,7,8,9]
y = x.in_groups(2)
print y[0]; puts
=end
