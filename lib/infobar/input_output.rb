module Infobar::InputOutput
  def newline
    @display.newline
    self
  end

  def clear
    @display.clear
    self
  end

  %i[ print printf putc puts ].each do |method|
    define_method(method) do |*a, &b|
      @display.clear
      @display.output.__send__(method, *a, &b)
    end
  end

  %i[ gets readline readlines ].each do |method|
    define_method(method) do |*a, &b|
      @display.clear
      @display.input.__send__(method, *a, &b)
    end
  end
end
