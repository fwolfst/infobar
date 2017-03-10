require 'infobar/trend'

class Infobar::Rate
  def initialize(value, fifo_values = [], **opts)
    opts[:format] = add_trend(opts[:format], fifo_values)
    @string = value.full? do
      if opts[:format].include?('%U')
        Tins::Unit.format(value, **opts)
      else
        opts[:format] % value
      end
    end.to_s
  end

  def to_s
    @string
  end

  private

  def add_trend(format, fifo_values)
    if fifo_values.empty?
      format.gsub('%t', ?⤿)
    else
      trend = Infobar::Trend.new(fifo_values)
      format.gsub('%t', trend.to_s)
    end
  end
end
