require 'spec_helper'

describe Infobar::Number do
  it 'can convert number into string' do
    expect(described_class.new(Math::PI).to_s).to start_with '3.141'
  end

  it 'can convert number into string for format' do
    expect(described_class.new(Math::PI, format: '%.3f').to_s).to eq '3.142'
  end

  it 'can convert number into string for unit format' do
    expect(
      described_class.new(
        1e6 * Math::PI,
        unit: ?B,
        prefix: 1024,
        format: '%.3f%U'
      ).to_s
    ).to eq '2.996MB'
  end
end

