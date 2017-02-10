require 'spec_helper'

describe Infobar::FIFO do
  let :fifo do
    described_class.new(3)
  end

  it 'has max_size' do
    expect(fifo.max_size).to eq 3
  end

  it 'has size' do
    expect(fifo.size).to eq 0
    fifo << 1
    expect(fifo.size).to eq 1
  end

  it 'has size <= max_size' do
    fifo << 1 << 2 << 3 << 4
    expect(fifo.size).to eq 3
  end

  it 'can be added to' do
    fifo << 1 << 2
    expect(fifo.to_a).to eq [ 1, 2 ]
  end

  it 'can be empty' do
    expect(fifo).to be_empty
  end

  it 'can be non-empty' do
    fifo << 1
    expect(fifo).not_to be_empty
  end

  it 'can be cleared' do
    fifo << 1
    expect(fifo).not_to be_empty
    expect(fifo.clear).to be_empty
  end
end
