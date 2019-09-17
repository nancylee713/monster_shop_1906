require 'rails_helper'

describe CouponUser, type: :model do
  describe "validations" do
    it { should validate_presence_of :user_id }
    it { should validate_presence_of :coupon_id }
    it { should validate_presence_of :is_redeemed }
    it { should validate_inclusion_of(:is_redeemed).in_array([true, false]) }
  end

  describe "relationships" do
    it {should belong_to :user}
    it {should belong_to :coupon}
  end

end
