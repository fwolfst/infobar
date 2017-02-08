module Infobar::InputOutput
  def newline
    display.newline
    self
  end

  def clear
    display.clear
    self
  end

  %i[ print printf putc puts ].each do |method|
    define_method(method) do |*a, &b|
      display.clear
      if display.output.respond_to?(method)
        display.output.public_send(method, *a, &b)
      end
    end
  end

  %i[ gets readline readlines ].each do |method|
    define_method(method) do |*a, &b|
      display.clear
      if display.input.respond_to?(method)
        display.input.public_send(method, *a, &b)
      end
    end
  end
end
