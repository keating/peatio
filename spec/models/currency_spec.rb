require 'spec_helper'

describe Currency do
  describe '.codes' do
    it 'returns all available currencies' do
      expect(Currency.codes).to eq({:cny=>1, :btc=>2})
    end
  end

  describe '.coin_urls' do
    it 'returns all available currency mapped to their respective rpc url' do
      expect(Currency.coin_urls[:btc]).to be_a(String)
    end
  end

  describe '.coin_wallets' do
    before do
      PaymentAddress.stubs(:max_address_index).returns(42)
    end

    it 'returns all available currency mapped to their respective deserialized wallet' do
      expect(Currency.coin_wallets[:btc]).to be_a(HDWallet)
    end

    it 'initializes wallet with max address index for each coin currency' do
      wallet = Currency.coin_wallets[:btc]
      expect(wallet.last_index).to eq(42)
    end
  end
end
