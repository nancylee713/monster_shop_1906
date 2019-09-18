class User < ApplicationRecord
  has_secure_password

  validates_presence_of :name, :password_digest
  validates :email, presence: true,
  format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i },
  uniqueness: { case_sensitive: false }
  validates :password, confirmation: true
  after_validation { self.errors.messages.delete(:password_digest) }

  has_many :item_orders
  has_many :orders, through: :item_orders
  belongs_to :merchant, optional: true

  has_many :addresses
  accepts_nested_attributes_for :addresses, allow_destroy: true, reject_if: :all_blank

  has_many :orders

  has_many :coupons
  # accepts_nested_attributes_for :coupons, allow_destroy: true, reject_if: :all_blank

  enum role: [:regular_user, :merchant_employee, :merchant_admin, :admin_user]

  def item_orders_by_merchant(order_id)
    self.merchant.item_orders.where(order: order_id)
  end

  def default_address
    self.addresses.first.to_s
  end
end
