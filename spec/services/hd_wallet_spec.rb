require 'spec_helper'

describe HDWallet do
  let(:master) { MoneyTree::Master.new }
  let(:serialized) { master.node_for_path("m/0'/0").to_serialized_address }
  let(:wallet) { described_class.new(serialized) }

  describe '#initialize' do
    it 'deserializes' do
      expect(wallet.root_node).to be_a(MoneyTree::Node)
      expect(wallet.root_node.private_key).to be_nil
    end

    it 'sets last index if passed in' do
      wallet = described_class.new(serialized, last_index: 42)
      expect(wallet.last_index).to eq(42)
    end

    context 'when serialization of a public node with private key is passed in' do
      let(:serialized) { master.node_for_path("m/0'/0").to_serialized_address(:private) }

      it 'throws an exception' do
        expect {
          wallet
        }.to raise_error(HDWallet::RootNodeError,
                         /Private key detected\. For security, only a base58 serialized public node stripped of private key is allowed/)
      end
    end

    context 'when serialization of a private node is passed in' do
      let(:serialized) { master.node_for_path("m/0'/0'").to_serialized_address() }

      it 'throws an exception' do
        expect {
          wallet
        }.to raise_error(HDWallet::RootNodeError,
                         /Private node detected\. For security, only a base58 serialized public node stripped of private key is allowed/)
      end
    end
  end

  describe '#next_address' do
    it 'generate addresses at 1 level down from the root' do
      address = wallet.next_address()

      subnode = wallet.root_node.subnode(0)
      expect(subnode.depth).to eq(wallet.root_node.depth + 1)
      expect(address).to eq(subnode.to_address)

      wallet.next_address()
      address = wallet.next_address()

      subnode = wallet.root_node.subnode(2)
      expect(address).to eq(subnode.to_address)
    end
  end
end
