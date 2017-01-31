class Infobar::Number
  def initialize(value, format: nil)
    duration = Tins::Duration.new(value)
    @string = format ? (format % value) : value.to_s
  end

  def to_s
    @string
  end
end
