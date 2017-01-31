require 'spec_helper'

describe Infobar::Duration do
  it 'can convert duration into string' do
    expect(described_class.new(3661).to_s).to eq '01:01:01'
  end

  it 'can convert duration into string for format' do
    expect(described_class.new(3661, format: '%h:%m').to_s).to eq '01:01'
  end
end

