class Infobar::Duration
  def initialize(value, format: nil)
    duration = Tins::Duration.new(value)
    @string =
      if format
        duration.format(format)
      else
        duration
      end.to_s
  end

  def to_s
    @string
  end
end
