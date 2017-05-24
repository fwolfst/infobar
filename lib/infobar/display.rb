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
    @style         = self.class.default_style.dup
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

  attr_reader :style

  def style=(new_style)
    @style.update(new_style)
  end

  def as_styles
    defined? @as_styles or self.as_styles = {}
    @as_styles
  end

  def as_styles=(styles)
    @as_styles = styles.to_h.dup
    @as_styles.default_proc = proc { style.subhash(/\Adone_/) }
  end

  def update(message:, counter:, force: false, **options)
    force and @frequency.reset
    @frequency.call do
      message = Infobar.convert_to_message(message)
      carriage_return
      self.style = options
      layout_bar(message, counter)
    end
  end

  private\
  def layout_bar(message, counter)
    cols = columns
    todo = message.to_str.center cols, replace_character

    if counter.total > 0
      max_done_length = counter.progressed * cols

      total_done = 0
      counter.as.each_with_index do |(name, count), i|
        done_fill     = as_styles[name].fetch(:done_fill) { @style[:done_fill] }
        done_fg_color = as_styles[name].fetch(:done_fg_color) { @style[:done_fg_color] }
        done_bg_color = as_styles[name].fetch(:done_bg_color) { @style[:done_bg_color] }

        as_progressed = count / counter.total.to_f
        as_done = as_progressed * cols
        total_done += as_done
        if counter.done? && i == counter.as.size - 1 && total_done <= max_done_length
          done = todo.dup
          todo = ''
        else
          done = todo.slice!(0, as_done)
        end
        done.gsub!(replace_character, done_fill[0])
        output << color(done_fg_color, on_color(done_bg_color, done))
      end
    end

    if todo.present?
      todo.gsub!(replace_character, @style[:todo_fill][0])
      output << color(@style[:todo_fg_color], on_color(@style[:todo_bg_color], todo))
    end
  end

  delegate :called, to: :frequency, as: :updates

  def reset(clear: true)
    clear && self.clear
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
