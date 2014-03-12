require 'spec_helper'

describe PaymentAddress do
  describe '.max_address_index' do
    it 'returns the max address index' do
      create(:payment_address, address_index: 2)
      create(:payment_address, address_index: 42)
      create(:payment_address, currency: Currency.codes[:cny], address_index: 43)

      expect(PaymentAddress.max_address_index Currency.codes[:btc]).to eq(42)
    end

    context 'when there is no address_index' do
      it { expect(PaymentAddress.max_address_index Currency.codes[:btc]).to eq(-1) }
    end
  end
end
