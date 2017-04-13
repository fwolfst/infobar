require 'tins/xt'
require 'complex_config'
require 'more_math'

class Infobar
end

require 'infobar/version'
require 'infobar/counter'
require 'infobar/display'
require 'infobar/message'
require 'infobar/fancy_interface'
require 'infobar/input_output'

class Infobar
  class << self
    prepend Tins::Delegate
  end
  include Tins::SexySingleton
  include Infobar::FancyInterface
  prepend Infobar::InputOutput
  include ComplexConfig::Provider::Shortcuts

  def initialize
    @counter = Infobar::Counter.new
    @display = Infobar::Display.new
    reset
  end

  def self.display
    Infobar.instance.display
  end

  attr_reader :message

  attr_reader :counter

  attr_reader :display

  attr_accessor :label

  delegate :started?, to: :counter

  delegate :done?, to: :counter

  delegate :finished?, to: :counter

  delegate :show?, to: :display

  delegate :show=, to: :display

  delegate :style=, to: :display

  def call(
    total:,
    current:   0,
    label:     cc.infobar?&.label || 'Infobar',
    message:   cc.infobar?&.message?&.to_h,
    show:      cc.infobar?&.show?,
    style:     cc.infobar?&.style?&.to_h,
    frequency: cc.infobar?&.frequency?,
    update:    false,
    finish:    nil
  )
    self.label = label
    counter.reset(total: total, current: current)
    @message = convert_to_message(message)
    show.nil? or self.show = show
    if update
      update(message: @message, force: true)
    else
      display.reset
    end
    frequency.nil? or display.frequency = frequency
    style.nil? or self.style = style
    self
  end

  def busy(**opts)
    block_given? or raise ArgumentError, 'block is required as an argument'
    duration = opts.delete(:sleep) || 0.1
    call({
      total: Float::INFINITY,
      message: { format: ' %l %te %s ', '%s' => { frames: :circle1 } },
    } | opts)
    ib = Thread.new {
      loop do
        +infobar
        sleep duration
      end
    }
    r = nil
    t = Thread.new { r = yield }
    t.join
    ib.kill
    r
  end

  def reset
    @message = convert_to_message('%l %c/%t in %te, ETA %e @%E %s')
    counter.reset(total: 0, current: 0)
    display.reset
    self
  end

  def update(message: nil, force: true)
    @message = convert_to_message(message)
    display.update(message: @message, progressed: counter.progressed, force: force)
    self
  end

  def progress(by: 1, message: nil, finish: true, force: false)
    counter.progress(by: by)
    @message = convert_to_message(message)
    display.update(message: @message, force: force, progressed: counter.progressed)
    finish && counter.done? and finish(message: finish)
    self
  end

  def finish(message: nil)
    counter.finish
    @message = convert_to_message(message)
    display.update(message: @message, force: true, progressed: counter.progressed)
    self
  end

  def convert_to_message(message)
    case message
    when Message
      message
    when Hash
      Message.new(message)
    when String
      Message.new format: message
    else
      @message
    end
  end
end

def Infobar(**opts)
  Infobar.(**opts)
end

class ::Object
  def infobar
    ::Infobar.instance
  end

  def with_infobar(**opts)
    case
    when total = opts[:total].ask_and_send(:to_sym)
      opts[:total] = __send__(total)
    when opts[:total].nil?
      opts[:total] = size
    end
    Infobar.(**opts)
    self
  end
end
