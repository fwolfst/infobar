class Infobar::Number
  def initialize(value, format: nil, unit: nil, prefix: 1000, separate: nil)
    case format
    when /%U/
      unit   ||= 'i/s'
      prefix ||= 1000
      @string = Tins::Unit.format(value, format: format, unit: unit, prefix: prefix)
    else
      format ||= '%f'
      @string = format ? format % value : value.to_s
      if Integer === value && separate
        @string.gsub!(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1#{separate}")
      end
    end
  end

  def to_s
    @string
  end
end
