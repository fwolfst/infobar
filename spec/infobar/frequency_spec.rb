require 'spec_helper'

describe Infobar::Frequency do
  let :frequency do
    described_class.new 1
  end

  it 'can be updated' do
    frequency.call {}
    expect(frequency.instance_eval { @update }).to be_present
  end

  it 'can be called' do
    called = false
    frequency.call do
      called = true
    end
    expect(called).to eq true
  end

  it 'does not execute block if called too soon' do
    Time.dummy(Time.now - 2) do
      expect(frequency.called).to eq 0
      frequency.call { }
      expect(frequency.called).to eq 1
      frequency.call { }
      expect(frequency.called).to eq 1
    end
    frequency.call { }
    expect(frequency.called).to eq 2
  end

  it 'can be reset' do
    expect(frequency.called).to eq 0
    frequency.call { }
    expect(frequency.called).to eq 1
    frequency.reset
    expect(frequency.called).to eq 0
  end

  it 'can be displayed' do
    expect(frequency.to_s).to eq '1.0'
  end
end
