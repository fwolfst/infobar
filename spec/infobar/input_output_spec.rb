require 'spec_helper'

describe Infobar::InputOutput do
  around do |example|
    infobar.display.output = Object.new
    infobar.display.input  = Object.new
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
end
