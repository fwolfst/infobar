require 'spec_helper'

describe Infobar::Rate do
  context 'with trend' do
    let :rate do
      described_class.new(23.45, (1..10).to_a, format: '%.2f%t')
    end

    it 'can be displayed' do
      expect(rate.to_s).to eq '23.45↗'
    end
  end
end
