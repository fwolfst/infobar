require 'spec_helper'

describe Infobar::Spinner do
  it 'spins according to count' do
    spinner = described_class.new
    expect(spinner.spin(0).to_s).to eq ?|
    expect(spinner.spin(1).to_s).to eq ?/
    expect(spinner.spin(2).to_s).to eq ?–
    expect(spinner.spin(3).to_s).to eq ?\\
    expect(spinner.spin(4).to_s).to eq ?|
  end

  it 'supports different frames' do
    spinner = described_class.new(%w[ . o O ])
    expect(spinner.spin(0).to_s).to eq ?.
    expect(spinner.spin(1).to_s).to eq ?o
    expect(spinner.spin(2).to_s).to eq ?O
    expect(spinner.spin(3).to_s).to eq ?.
  end

  it 'supports different predefined frames' do
    expect do
      described_class.new(:fuck_it)
    end.to raise_error(KeyError)
    spinner = described_class.new(:cross)
    expect(spinner.spin(0).to_s).to eq ?+
    expect(spinner.spin(1).to_s).to eq ?×
    expect(spinner.spin(2).to_s).to eq ?+
  end

  it 'can spin randomly' do
    srand 1
    spinner = described_class.new(:braille7)
    expect(spinner.spin(:random).to_s).to eq ?⣟
    expect(spinner.spin(:random).to_s).to eq ?⢿
  end
end
