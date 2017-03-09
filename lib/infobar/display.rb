require 'term/ansicolor'
require 'stringio'
require 'infobar/frequency'

class Infobar::Display
  class << self
    prepend Tins::Delegate
  end
  include Term::ANSIColor

  def self.default_style
    {
      done_fill:     ?░,
      done_fg_color: 22,
      done_bg_color: 40,
      todo_fill:     ' ',
      todo_fg_color: 40,
      todo_bg_color: 22,
    }
  end

  def initialize
    self.output    = $stdout
    self.input     = $stdin
    self.frequency = 0.05
    @show          = true
    self.style = self.class.default_style
  end

  def frequency=(duration)
    @frequency = Infobar::Frequency.new(duration)
  end

  attr_reader :frequency

  attr_accessor :show

  def show?
    @show
  end

  def output=(io)
    @output = io
    @output.ask_and_send(:respond_to?, :sync=, true)
  end

  def output
    if show?
      @output
    else
      NULL
    end
  end

  attr_writer :input

  def input
    if show?
      @input
    else
      NULL
    end
  end

  def style
    self.class.default_style.each_key.each_with_object({}) do |attribute, h|
      h[attribute] = instance_variable_get "@#{attribute}"
    end
  end

  def style=(new_style)
    self.class.default_style.each_key do |attribute|
      value = new_style[attribute]
      value.nil? and next
      instance_variable_set "@#{attribute}", value
    end
    self
  end

  def update(message:, progressed:, force: false, **options)
    force and @frequency.reset
    @frequency.call do
      message = Infobar.convert_to_message(message)
      carriage_return
      self.style = options
      cols = columns
      todo = message.to_str.center cols, replace_character
      done = todo.slice!(0, (progressed * cols))
      done.gsub!(replace_character, @done_fill[0])
      todo.gsub!(replace_character, @todo_fill[0])
      output << color(@done_fg_color, on_color(@done_bg_color, done)) +
        color(@todo_fg_color, on_color(@todo_bg_color, todo))
    end
  end

  delegate :called, to: :frequency, as: :updates

  def reset
    clear
    self.style = self.class.default_style
    self
  end

  def clear
    carriage_return
    output << ' ' * columns
    carriage_return
    @frequency.reset
    self
  end

  def carriage_return
    output << ?\r
    self
  end

  def newline
    output << $/
    self
  end

  private

  def replace_character
    "\uFFFC"
  end

  def columns
    Tins::Terminal.columns
  end
end
