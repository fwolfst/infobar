class Infobar::FIFO
  include Enumerable

  def initialize(n)
    @n = n
    clear
  end

  def max_size
    @n
  end

  def <<(value)
    @i += 1
    if @i > @n
      @values.shift
      @i -= 1
    end
    @values.push(value)
    self
  end

  def each(&block)
    @values.each(&block)
    self
  end

  def empty?
    @i.zero?
  end

  alias size count

  def clear
    @i = 0
    @values = []
    self
  end
end

