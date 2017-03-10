require 'spec_helper'

describe Infobar::Message do
  let :format do
    '%c %t %T %l %p %q %P %Q %te %tt %e %E %r %a %s %%'
  end

  let :message do
    described_class.new(format: format, '%p' => { format: '%.2f' })
  end

  let :now do
    Time.parse('2011-11-11 11:11:11')
  end


  before do
    Time.dummy(now - 3) do
      Infobar.(current: 21, total: 42, label: 'Test')
    end
    Time.dummy(now - 2) do
      +infobar
    end
    Time.dummy(now - 1) do
      +infobar
    end
  end

  after do
    infobar.reset
  end

  it 'can be interpolated' do
    Time.dummy(now) do
      expect(message.to_str).to eq(
        "23 42 19 Test 0.55 0.452 54.76 45.24 00:00:02 00:00:21 00:00:19 11:11:30 1.000i/s→ 00:01.000000 – %"
      )
    end
  end

  it 'can turn spinner into a message after finishing' do
    Time.dummy(now) do
      srand 1
      message = described_class.new(
        format: 'hello %s',
        '%s' => {
          random: true,
          message: {
            format: 'world at %E',
            '%E' => { format: '%F %T' }
          }
        }
      )
      expect(message.to_str).to eq 'hello /'
      infobar.finish
      expect(message.to_str).to eq 'hello world at 2011-11-11 11:11:11'
    end
  end

  it 'can display eta in native format' do
    Time.dummy(now) do
      message =
        described_class.new(format: 'test %E', '%E' => { format: nil }).to_str
      expect(message).to eq "test #{now + 19}"
    end
  end

  it 'can be converted into a format string' do
    expect(message.to_s).to eq format
  end

  it 'can be converted into a hash' do
    expect(message.to_hash).to eq(
      format: format,
      '%p' => { format: '%.2f' }
    )
  end
end
