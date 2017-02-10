class Infobar::Trend
  def initialize(values, symbols: %i[ ↘ → ↗ ])
    @values  = values
    @symbols = symbols
    @string  = arrow
  end

  def to_s
    @string
  end

  private

  def arrow
    lr = MoreMath::LinearRegression.new(@values)
    case
    when lr.slope_zero?
      @symbols[1]
    when lr.a > 0
      @symbols[2]
    else
      @symbols[0]
    end.to_s
  end
end
