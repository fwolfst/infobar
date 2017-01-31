require 'spec_helper'

describe Infobar::Timer do
  let :timer do
    described_class.new
  end

  it 'has default average time of 0.0' do
    expect(timer.average_time).to eq 0.0
  end

  it 'has default rate of 0.0' do
    expect(timer.rate).to eq 0.0
  end

  it 'can be added to' do
    now = Time.now
    timer.add(now, 2)
    expect(timer.average_time).to eq 0.0
    expect(timer.rate).to eq 0.0
    expect(timer.n).to eq 1
    timer.add(now + 2, 4)
    expect(timer.average_time).to be_within(1e-3).of(3.0 / 4)
    expect(timer.rate).to be_within(1e-3).of(4 / 3.0)
    expect(timer.n).to eq 2
    timer.add(now + 3, 1)
    expect(timer.average_time).to be_within(1e-3).of(0.8333)
    expect(timer.rate).to be_within(1e-3).of(1 / 0.8333)
    expect(timer.n).to eq 3
  end
end
