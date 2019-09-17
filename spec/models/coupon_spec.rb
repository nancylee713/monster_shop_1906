require 'rails_helper'

describe Coupon, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_uniqueness_of :name }
    it { should validate_length_of(:name).is_equal_to(10) }
    it { should validate_presence_of :value }
    it { should validate_presence_of :item_id }
    it { should validate_numericality_of(:item_id).is_greater_than_or_equal_to(1).only_integer }
    it { should validate_presence_of :is_enabled }
    it { should validate_inclusion_of(:is_enabled).in_array([true, false]) }
    it { should validate_inclusion_of(:is_percent).in_array([true, false]) }
  end

  describe "relationships" do
    it {should have_many :coupon_users}
    it {should have_many(:users).through(:coupon_users)}
    it {should belong_to :merchant}
  end

  describe "methods" do
    it "##generate_code" do
      coupon_1 = Coupon.new
      coupon_2 = Coupon.new

      expect(coupon_1).to_not eq(coupon_2)
      expect(coupon_1.generate_code.length).to eq(10)

    end
  end
end