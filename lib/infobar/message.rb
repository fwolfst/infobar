require 'infobar/spinner'
require 'infobar/duration'
require 'infobar/number'
require 'infobar/rate'

class Infobar::Message
  class << self
    prepend Tins::Delegate

    def register(directive, **opts, &block)
      directives.key?(directive) and
        warn "Overwriting old directive #{directive}."
      directives[directive]                = block
      directive_default_options[directive] = opts
      self
    end

    def directives
      @directives ||= {}
    end

    def directive_default_options
      @directive_default_options ||= {}
    end
  end

  # current counter value of items
  register('%c', format: '%d', separate: ?_) do |directive, opts|
    Infobar::Number.new(infobar.counter.current, **opts)
  end

  # total counter value of items
  register('%t', format: '%d', separate: ?_) do |directive, opts|
    Infobar::Number.new(infobar.counter.total, **opts)
  end

  # number of items to go
  register('%T', format: '%d', separate: ?_) do |directive, opts|
    Infobar::Number.new(infobar.counter.to_go, **opts)
  end

  # label of progress bar
  register '%l' do
    infobar.label
  end

  # progressed so far as a float in 0..1
  register('%p', format: '%.3f') do |directive, opts|
    Infobar::Number.new(infobar.counter.progressed, **opts)
  end

  # not yet progressed as a float in 0..1
  register('%q', format: '%1.3f') do |directive, opts|
    Infobar::Number.new(1 - infobar.counter.progressed, **opts)
  end

  # progressed as a percentage float in 0..100
  register('%P', format: '%3.2f') do |directive, opts|
    Infobar::Number.new(100 * infobar.counter.progressed, **opts)
  end

  # not yet progressed as a percentage float in 0..100
  register('%Q', format: '%2.2f') do |directive, opts|
    Infobar::Number.new(100 - 100 * infobar.counter.progressed, **opts)
  end

  # time elapsed as a duration
  register('%te', format: '%D') do |directive, opts|
    Infobar::Duration.new(infobar.counter.time_elapsed, **opts)
  end

  # total time as a duration
  register('%tt', format: '%D') do |directive, opts|
    Infobar::Duration.new(infobar.counter.total_time, **opts)
  end

  # ETA as a duration
  register('%e', format: '%D') do |directive, opts|
    Infobar::Duration.new(infobar.counter.time_remaining, **opts)
  end

  # ETA as a datetime
  register('%E', format: '%T') do |directive, opts|
    if format = opts[:format]
      infobar.counter.eta.strftime(format)
    else
      infobar.counter.eta
    end
  end

  # rate with or without units
  register('%r', unit: 'i/s', prefix: 1000, format: '%.3f%U%t') do |directive, opts|
    Infobar::Rate.new(infobar.counter.rate, infobar.counter.fifo_rate, **opts)
  end

  # average time as a duration
  register('%a', format: '%m:%s.%f') do |directive, opts|
    Infobar::Duration.new(infobar.counter.average_time, **opts)
  end

  # spinner
  register('%s', frames: :pipe, message: ?✓) do |directive, opts|
    if infobar.finished?
      if message = opts[:message]
        infobar.convert_to_message(message).to_str
      end
    elsif opts[:random]
      Infobar::Spinner.new(opts[:frames]).spin(:random)
    else
      Infobar::Spinner.new(opts[:frames]).spin(infobar.display.updates)
    end
  end

  # literal percentage character
  register '%%' do
    ?%
  end

  def initialize(opts)
    @opts = opts.each_with_object({}) { |(k, v), h| h[k.to_s] = v }
  end

  attr_reader :opts

  def directives
    self.class.directives
  end

  def directive_default_options
    self.class.directive_default_options
  end

  def opts_for(directive)
    @opts.fetch(directive, directive_default_options[directive])
  end

  def to_str
    keys = directives.keys.sort_by { |k| -k.size }
    format.gsub(/(?<!%)(#{keys * ?|})/) do
      directives[$1].call($1, opts_for($1))
    end
  end

  def format
    @opts['format']
  end

  alias to_s format

  def to_hash
    result = @opts.dup
    result[:format] = result.delete('format')
    result
  end
end
