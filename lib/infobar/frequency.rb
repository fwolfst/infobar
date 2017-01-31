class Infobar::Frequency
  def initialize(duration)
    @duration = duration.to_f
    @called   = 0
  end

  attr_reader :duration

  attr_reader :called

  def update(now: Time.now)
    @update = now
    @called += 1
  end

  def call(&block)
    now = Time.now
    if !@update || now - @update > @duration
      update now: now
      block.call
    end
  end

  def reset
    @update = nil
    @called = 0
    self
  end

  def to_s
    @duration.to_s
  end
end
