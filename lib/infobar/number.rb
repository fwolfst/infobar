class Infobar::Number
  def initialize(value, format: nil, separate: nil)
    duration = Tins::Duration.new(value)
    @string = format ? format % value : value.to_s
    if Integer === value && separate
      @string.gsub!(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1#{separate}")
    end
  end

  def to_s
    @string
  end
end
