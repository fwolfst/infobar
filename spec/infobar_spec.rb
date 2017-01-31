require 'spec_helper'

describe Infobar do
  after do
    infobar.reset
    infobar.show = true
  end

  it 'can be called with total' do
    expect(infobar).not_to receive(:update)
    Infobar(total: 10)
    expect(infobar.counter.total).to eq 10
  end

  it 'can be called and update instantly' do
    expect(infobar).to receive(:update).and_call_original
    Infobar(total: 10, update: true)
  end

  it 'can be called via toplevel method' do
    Infobar(total: 10)
    expect(infobar.counter.total).to eq 10
  end

  it 'can be progressing' do
    Infobar(total: 10)
    expect(infobar.counter.current).to eq 0
    expect(infobar.progress).to eq infobar
    expect(infobar.counter.current).to eq 1
  end

  it 'can be progressing with unary +' do
    Infobar(total: 10)
    expect(infobar.counter.current).to eq 0
    expect(+infobar).to eq infobar
    expect(infobar.counter.current).to eq 1
  end

  it 'can be progressing by n' do
    Infobar(total: 10)
    expect(infobar.counter.current).to eq 0
    expect(infobar.progress(by: 3)).to eq infobar
    expect(infobar.counter.current).to eq 3
  end

  it 'can be progressing by n with binary +' do
    infobar = Infobar(total: 10)
    expect(infobar.counter.current).to eq 0
    expect(infobar + 3).to eq infobar
    expect(infobar.counter.current).to eq 3
    expect(2 + infobar).to eq infobar
    expect(infobar.counter.current).to eq 5
    expect(infobar += 2).to eq infobar # only for variables
    expect(infobar.counter.current).to eq 7
  end

  it 'can be progressing with <<' do
    Infobar(total: 10)
    expect(infobar.counter.current).to eq 0
    expect(infobar << 1).to eq infobar
    expect(infobar.counter.current).to eq 1
  end

  it 'can be progressing by n push/add' do
    Infobar(total: 10)
    expect(infobar.counter.current).to eq 0
    expect(infobar.push(1, 2)).to eq infobar
    expect(infobar.counter.current).to eq 2
    expect(infobar.add(1, 2)).to eq infobar
    expect(infobar.counter.current).to eq 4
  end

  it 'can be reset via ~' do
    expect(infobar).to receive(:reset).twice
    ~infobar
  end

  it 'finishes by progress' do
    Infobar(total: 10)
    expect(infobar).not_to be_finished
    infobar + 10
    expect(infobar).to be_finished
  end

  it 'can avoid finishing by progress' do
    Infobar(total: 10)
    expect(infobar).not_to be_finished
    infobar.progress(by: 10, finish: false)
    expect(infobar).not_to be_finished
  end

  it 'can sent specific message if finished by progress' do
    Infobar(total: 10)
    expect(infobar).not_to be_finished
    expect(infobar).to receive(:finish).with(message: 'hello').
      and_call_original
    infobar.progress(by: 10, finish: 'hello')
    expect(infobar).to be_finished
  end

  it 'can be finished eplicitely' do
    Infobar(total: 10)
    expect(infobar).not_to be_finished
    message = Infobar::Message.new(format: 'hello')
    expect(infobar.display).to receive(:update).with(
      message: message,
      force: true,
      progressed: 0.0
    ).and_call_original
    infobar.finish message: message
    expect(infobar).to be_finished
  end

  it 'can output newline' do
    expect(infobar.display).to receive(:newline)
    infobar.newline
  end

  it 'can be hidden' do
    expect(infobar.display.output).not_to receive(:<<)
    infobar.show = false
    infobar.newline
  end

  it 'can set a new style' do
    Infobar(total: 10, style: { done_fill: ?X })
    output = ''
    infobar.display.output = output
    infobar.progress(force: true)
    expect(output).to include 'X'
  end

  it 'can set display frequency' do
    expect(infobar.display.frequency.duration).to be_within(3e-3).of 0.05
    infobar.display.frequency = 0.1
    expect(infobar.display.frequency.duration).to be_within(3e-3).of 0.1
  end

  it 'can interpret size on an object' do
    [ 1, 2, 3 ].with_infobar
    expect(infobar.counter.total).to eq 3
  end

  it 'can interpret size on an object' do
    '🇩🇪'.with_infobar(total: :bytesize)
    expect(infobar.counter.total).to eq 8
  end
end
