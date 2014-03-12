class PaymentAddress < ActiveRecord::Base
  extend Enumerize
  enumerize :currency, in: Currency.codes, scope: true

  belongs_to :account

  has_many :transactions, class_name: 'PaymentTransaction', foreign_key: 'address', primary_key: 'address'

  scope :using, -> { last }

  validates_uniqueness_of :address, :address_index

  def self.max_address_index(currency)
    self.with_currency(currency).maximum(:address_index) || -1
  end
end
