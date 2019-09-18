require 'rails_helper'

describe Coupon, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_uniqueness_of :name }
    it { should validate_length_of(:name).is_equal_to(10) }
    it { should validate_presence_of :value }
    it { should validate_presence_of :item_id }
    it { should validate_numericality_of(:item_id).is_greater_than_or_equal_to(1).only_integer }
    it { should validate_inclusion_of(:is_enabled).in_array([true, false]) }
    it { should validate_inclusion_of(:is_percent).in_array([true, false]) }
    it { should validate_inclusion_of(:is_redeemed).in_array([true, false])}
  end

  describe "relationships" do
    it {should belong_to :merchant}
    it {should belong_to(:user).optional}
    it {should have_one :order}
  end

  describe "methods" do
    it "##generate_code" do
      coupon_1 = Coupon.new
      coupon_2 = Coupon.new

      expect(coupon_1).to_not eq(coupon_2)
      expect(coupon_1.generate_code.length).to eq(10)
    end

    it "#toggle_status" do
      coupon_1 = Coupon.new
      expect(coupon_1.is_enabled).to be true
      coupon_1.toggle_status
      expect(coupon_1.is_enabled).to be false
    end

    it "#recalculate_order_total" do
      user = create(:user)
      address = user.addresses.create(attributes_for(:address))
      merchant = create(:merchant)
      item = merchant.items.create(attributes_for(:item, price: 100))
      order = create(:order, user: user, address: address)
      item_order = ItemOrder.create!(order: order, item: item, quantity: 1, price: item.price, user: user)
      coupon_1 = create(:coupon, value: 5, is_percent: false, merchant: merchant, item_id: item.id, user: user)

      cart = Cart.new({"#{item.id}"=>1})

      discounted = item_order.subtotal - coupon_1.value

      expect(coupon_1.recalculate_order_total(cart)).to eq(discounted)

      coupon_2 = create(:coupon, value: 105, is_percent: false, merchant: merchant, item_id: item.id, user: user)

      expect(coupon_2.recalculate_order_total(cart)).to eq(0)
    end

    it "show_coupon" do
      merchant = create(:merchant)
      item = merchant.items.create(attributes_for(:item, id: 1, name: "Test"))
      coupon_1 = Coupon.create!(name: "ABCDE12345", merchant: merchant, item_id: item.id, value: 5, is_percent: false)

      expect(coupon_1.show_coupon).to eq("Test, $5.0 OFF")

      coupon_2 = Coupon.create!(name: "ABCDE67890", merchant: merchant, item_id: item.id, value: 5, is_percent: true)

      expect(coupon_2.show_coupon).to eq("Test, 5.0% OFF")
    end
  end
end
