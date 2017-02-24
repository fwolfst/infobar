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
  register '%c' do
    Infobar.counter.current
  end

  # total counter value of items
  register '%t' do
    Infobar.counter.total
  end

  # number of items to go
  register '%T' do
    Infobar.counter.to_go
  end

  # label of progress bar
  register '%l' do
    Infobar.label
  end

  # progressed so far as a float in 0..1
  register('%p', format: '%.3f') do |directive, opts|
    Infobar::Number.new(Infobar.counter.progressed, **opts)
  end

  # not yet progressed as a float in 0..1
  register('%q', format: '%1.3f') do |directive, opts|
    Infobar::Number.new(1 - Infobar.counter.progressed, **opts)
  end

  # progressed as a percentage float in 0..100
  register('%P', format: '%3.2f') do |directive, opts|
    Infobar::Number.new(100 * Infobar.counter.progressed, **opts)
  end

  # not yet progressed as a percentage float in 0..100
  register('%Q', format: '%2.2f') do |directive, opts|
    Infobar::Number.new(100 - 100 * Infobar.counter.progressed, **opts)
  end

  # time elapsed as a duration
  register('%te', format: '%h:%m:%s') do |directive, opts|
    Infobar::Duration.new(Infobar.counter.time_elapsed, **opts)
  end

  # total time as a duration
  register('%tt', format: '%h:%m:%s') do |directive, opts|
    Infobar::Duration.new(Infobar.counter.total_time, **opts)
  end

  # ETA as a duration
  register('%e', format: '%h:%m:%s') do |directive, opts|
    Infobar::Duration.new(Infobar.counter.time_remaining, **opts)
  end

  # ETA as a datetime
  register('%E', format: '%T') do |directive, opts|
    if format = opts[:format]
      Infobar.counter.eta.strftime(format)
    else
      Infobar.counter.eta
    end
  end

  # rate with or without units
  register('%r', unit: nil, prefix: 1000, format: '%.3f%U%t') do |directive, opts|
    Infobar::Rate.new(Infobar.counter.rate, Infobar.counter.fifo_rate, **opts)
  end

  # average time as a duration
  register('%a', format: '%m:%s.%f') do |directive, opts|
    Infobar::Duration.new(Infobar.counter.average_time, **opts)
  end

  # spinner
  register('%s', frames: :pipe, message: ?✓) do |directive, opts|
    if Infobar.finished?
      if message = opts[:message]
        Infobar.convert_to_message(message).to_str
      end
    elsif opts[:random]
      Infobar::Spinner.new(opts[:frames]).spin(:random)
    else
      Infobar::Spinner.new(opts[:frames]).spin(Infobar.display.updates)
    end
  end

  # literal percentage character
  register '%%' do
    ?%
  end

  def initialize(opts = {})
    @format = opts.delete(:format) or
      raise ArgumentError, 'format option required'
    @opts = opts.each_with_object({}) { |(k, v), h| h[k.to_s] = v }
  end

  attr_reader :opts

  delegate :directives, to: self

  delegate :directive_default_options, to: self

  def opts_for(directive)
    @opts.fetch(directive, directive_default_options[directive])
  end

  def to_str
    keys = directives.keys.sort_by { |k| -k.size }
    @format.gsub(/(?<!%)(#{keys * ?|})/) do
      directives[$1].call($1, opts_for($1))
    end
  end

  attr_reader :format

  alias to_s format

  def to_hash
    {
      format: format,
    }.merge(@opts)
  end
end
