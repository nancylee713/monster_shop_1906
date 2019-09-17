class Coupon < ApplicationRecord
  validates :name, presence: true, uniqueness: true, length: { is: 10 }
  validates :value, presence: true, numericality: { only_integer: true }
  validates_presence_of :is_enabled, inclusion: { in: [true, false] }

  has_many :coupon_users, :dependent => :destroy
  has_many :users, through: :coupon_users

  belongs_to :merchant
end
