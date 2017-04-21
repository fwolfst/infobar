require 'infobar/timer'

class Infobar::Counter
  class << self
    prepend Tins::Delegate
  end

  def initialize
    reset
  end

  attr_reader :current

  attr_reader :total

  attr_reader :as

  def reset(total: 0, current: 0)
    @current  = current
    @as       = Hash.new(0).update(nil => current)
    @total    = total
    @start    = nil
    @finished = false
    @timer    = Infobar::Timer.new
    self
  end

  delegate :rate, to: :@timer

  delegate :fifo, to: :@timer, as: :fifo_rate

  delegate :average_time, to: :@timer

  def started?
    @start
  end

  def finished?
    @finished
  end

  def finish
    @finished = Time.now
    self
  end

  def progress(by: 1, as: nil)
    if !finished? && by >= 1
      now = Time.now
      @start ||= now
      @timer.add(now, by)
      @current += by
      @as[as] += 1
    end
    self
  end

  def done?
    @current >= @total
  end

  def to_go
    [ total - current, 0 ].max
  end

  def to_go?
    to_go.nonzero?
  end

  def time_remaining
    if @finished
      0.0
    else
      average_time * to_go
    end
  end

  def eta
    if @finished
      @finished
    else
      Time.now + time_remaining
    end
  end

  def time_elapsed
    case
    when @finished && @start
      @finished - @start
    when @start
      Time.now - @start
    else
      0.0
    end
  end

  def total_time
    time_elapsed + time_remaining
  end

  def progressed
    if @total.zero?
      0.0
    else
      @current / @total.to_f
    end
  end
end
