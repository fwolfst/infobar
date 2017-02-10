require 'infobar/fifo'

class Infobar::Timer
  def initialize
    @n    = 0
    @x    = 0.0
    @fifo = Infobar::FIFO.new(30)
  end

  attr_reader :x

  attr_reader :n

  attr_reader :fifo

  def add(time, count)
    case @n
    when 0
      @n += 1
    when 1
      @n -= 1
      duration = time - @time_last
      self << (duration / @count_last)
      self << (duration / count.to_f)
    else
      duration = time - @time_last
      self << (duration / count.to_f)
    end
    @time_last, @count_last = time, count
    self
  end

  def rate
    if @x.zero?
      0.0
    else
      1.0 / @x
    end
  end

  def average_time
    @x
  end

  protected

  def <<(x)
    @n +=1
    @x += (x - @x) / @n
    @fifo << rate
    self
  end
end
