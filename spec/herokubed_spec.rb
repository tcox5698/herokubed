require 'herokubed'

describe Herokubed do
  describe '.hi' do
    subject { Herokubed.hi }

    it { is_expected.to be_nil }
  end

end