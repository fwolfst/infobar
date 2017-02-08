require 'spec_helper'

describe Infobar::InputOutput do
  io_double = -> {
    Class.new do
      def puts(*) end

      def gets(*) end
    end.new
  }

  around do |example|
    infobar.display.output = io_double.()
    infobar.display.input  = io_double.()
    example.run
    infobar.display.output = $stdout
    infobar.display.input  = $stdin
    infobar.reset
  end

  it 'can puts after clearing' do
    expect(infobar.display).to receive(:clear)
    expect(infobar.display.output).to receive(:puts)
    infobar.puts 'hello'
  end

  it 'can gets after clearing' do
    expect(infobar.display).to receive(:clear)
    expect(infobar.display.input).to receive(:gets)
    infobar.gets
  end

  it 'can output newline' do
    expect(infobar.display).to receive(:newline)
    infobar.newline
  end

  it 'can clear the infobar' do
    expect(infobar.display).to receive(:clear)
    infobar.clear
  end

  it 'does not puts if not showing' do
    begin
      expect(infobar.display.output).not_to receive(:puts)
      infobar.show = false
      infobar.puts 'hello'
    rescue
      infobar.show = true
    end
  end
end
