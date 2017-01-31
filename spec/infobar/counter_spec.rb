require 'spec_helper'

describe Infobar::Counter do
  let :counter do
    described_class.new
  end

  it 'can be initialized' do
    expect(counter).to be_a described_class
    expect(counter.current).to eq 0
    expect(counter.total).to eq 0
    expect(counter).not_to be_started
  end

  it 'can progress' do
    expect(counter.progress).to eq counter
    expect(counter).to be_started
    expect(counter.current).to eq 1
    expect(counter.total).to eq 0
  end

  it 'can progress by arbitrary value' do
    expect(counter.progress(by: 23)).to eq counter
    expect(counter).to be_started
    expect(counter.current).to eq 23
    expect(counter.total).to eq 0
  end

  it 'can be done' do
    counter.reset(total: 3)
    expect(counter).not_to be_done
    expect(counter.progress(by: 2)).to eq counter
    expect(counter).not_to be_done
    expect(counter.progress).to eq counter
    expect(counter).to be_done
    expect(counter.progress(by: 23)).to eq counter
    expect(counter).to be_done
  end

  it 'can be finished' do
    counter.reset(total: 3)
    expect(counter).not_to be_started
    expect(counter).not_to be_finished
    expect(counter.progress(by: 1)).to eq counter
    expect(counter).to be_started
    expect(counter).not_to be_finished
    expect(counter.finish).to eq counter
    expect(counter).to be_finished
  end

  it 'can tell how far it has progressed' do
    counter.reset(total: 3)
    expect(counter.progressed).to be_zero
    expect(counter.progress).to eq counter
    expect(counter.progressed).to be_within(1e-3).of(1 / 3.0)
    expect(counter.progress).to eq counter
    expect(counter.progressed).to be_within(1e-3).of(2 / 3.0)
    expect(counter.progress).to eq counter
    expect(counter.progressed).to be_within(1e-3).of(1)
  end

  it 'cannot progress without knowing how far to go' do
    expect(counter.progressed).to eq 0.0
    expect(counter.progress).to eq counter
    expect(counter.progressed).to eq 0.0
  end

  it 'can tell how many counts we have' do
    expect(counter.current).to be_zero
    expect(counter.progress).to eq counter
    expect(counter.current).to eq 1
    expect(counter.progress).to eq counter
    expect(counter.current).to eq 2
    expect(counter.progress).to eq counter
    expect(counter.current).to eq 3
  end

  it 'can tell how far it still has to go' do
    counter.reset(total: 3)
    expect(counter.to_go).to eq 3
    expect(counter.to_go?).to eq 3
    expect(counter).to be_to_go
    expect(counter.progress(by: 2)).to eq counter
    expect(counter.to_go).to eq 1
    expect(counter.to_go?).to eq 1
    expect(counter).to be_to_go
    expect(counter.progress).to eq counter
    expect(counter.to_go).to be_zero
    expect(counter.to_go?).to be_nil
    expect(counter).not_to be_to_go
  end

  it 'time_remaining' do
    counter.reset(total: 3)
    now = Time.now
    Time.dummy(now - 2) { counter.progress }
    Time.dummy(now - 1) { counter.progress }
    expect(counter.time_remaining).to be_within(1e-3).of 1
    counter.finish
    expect(counter.time_remaining).to be_zero
  end

  it 'time_elapsed' do
    counter.reset(total: 3)
    now = Time.now
    expect(counter.time_elapsed).to be_within(1e-3).of 0
    Time.dummy(now - 3) { counter.progress }
    Time.dummy(now - 2) { counter.progress }
    Time.dummy(now - 1) do
      expect(counter.time_elapsed).to be_within(1e-3).of 2
    end
    counter.finish
    expect(counter.time_elapsed).to be_within(1e-3).of 3
  end

  it 'eta' do
    counter.reset(total: 3)
    now = Time.now
    Time.dummy(now - 2) { counter.progress }
    Time.dummy(now - 1) {
      counter.progress
      expect(counter.eta.to_i).to eq now.to_i
    }
    counter.finish
    expect(counter.eta.to_i).to eq now.to_i
  end

  it 'total_time' do
    counter.reset(total: 3)
    now = Time.now
    Time.dummy(now - 2) { counter.progress }
    Time.dummy(now - 1) { counter.progress }
    expect(counter.total_time).to be_within(1e-3).of 3
  end
end
