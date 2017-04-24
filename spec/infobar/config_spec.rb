require 'spec_helper'

describe 'Infobar config' do
  before do
    ComplexConfig::Provider.config_dir =
      Pathname.new(__FILE__).join('../../config')
    extend ComplexConfig::Provider::Shortcuts
    ComplexConfig::Provider.reload
  end

  after do
    ComplexConfig::Provider.config_dir = nil
    ComplexConfig::Provider.reload
  end

  it 'configuration exists' do
    expect(cc.infobar?).not_to be_nil
  end

  it 'configures default infobar' do
    Infobar(total: 23)
    expect(infobar.display.output).to receive(:<<).with(?\r)
    expect(infobar.display.output).to receive(:<<).with(
      "\e[38;5;22m\e[48;5;40m\e[0m\e[0m"
    )
    expect(infobar.display.output).to receive(:<<).with(%r(Progress 0/23.*⣽))
    infobar.update
    expect(infobar).to be_show
  end
end
