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
end

=begin
tss = TimeSeriesim.new
ary = tss.get_n_values(10,1.0)
print ary; puts
=end
