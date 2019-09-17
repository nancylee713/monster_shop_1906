class CouponUser < ApplicationRecord
  validates_presence_of :user_id, :coupon_id
  validates_presence_of :is_redeemed, inclusion: { in: [true, false] }

  belongs_to :user
  belongs_to :coupon
end
