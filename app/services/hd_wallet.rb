class HDWallet
  class RootNodeError < StandardError
    def initialize message
      super message << " For security, only a base58 serialized public node stripped of private key is allowed."
    end
  end

  attr_reader :root_node, :last_index

  def initialize(public_base58, options={})
    root_node = MoneyTree::Node.from_serialized_address(public_base58)

    error_messages = []
    error_messages << "Private key detected." if(root_node.private_key.present?)
    error_messages << "Private node detected." if(root_node.is_private?)

    if(error_messages.present?)
      raise RootNodeError.new(error_messages.join(' '))
    end
    @root_node = root_node
    @last_index = options[:last_index] || -1
  end

  def next_address
    i = last_index + 1
    address = root_node.subnode(i).to_address
    @last_index = i

    address
  end
end

