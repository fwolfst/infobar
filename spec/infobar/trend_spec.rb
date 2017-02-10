require 'spec_helper'

describe Infobar::Trend do
  let :trend do
    described_class.new(values)
  end

  context 'downwards' do
    let :values do
      (1..10).to_a.reverse
    end

    it 'can be a string' do
      expect(trend.to_s).to eq ?↘
    end
  end

  context 'sideways' do
    let :values do
      [ Math::PI ] * 10
    end

    it 'can be a string' do
      expect(trend.to_s).to eq ?→
    end
  end

  context 'upwards' do
    let :values do
      (1..10).to_a
    end

    it 'can be a string' do
      expect(trend.to_s).to eq ?↗
    end
  end
end
