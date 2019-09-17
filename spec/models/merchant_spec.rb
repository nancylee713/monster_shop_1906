require 'rails_helper'

describe Merchant, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :address }
    it { should validate_presence_of :city }
    it { should validate_presence_of :state }
    it { should validate_presence_of :zip }
    it { should validate_inclusion_of(:enabled?).in_array([true,false]) }
  end

  describe "relationships" do
    it {should have_many :items}
    it {should have_many :coupons}
  end

  describe 'instance methods' do
    before(:each) do
      @user = create(:user)
      @address = create(:address)
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    end

    it 'no_orders' do
      expect(@meg.no_orders?).to eq(true)

      order_1 = create(:order, user: @user, address: @address)
      item_order_1 = @user.item_orders.create!(order: order_1, item: @tire, price: @tire.price, quantity: 2)

      expect(@meg.no_orders?).to eq(false)
    end

    it 'item_count' do
      chain = @meg.items.create(name: "Chain", description: "It'll never break!", price: 30, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 22)

      expect(@meg.item_count).to eq(2)
    end

    it 'average_item_price' do
      chain = @meg.items.create(name: "Chain", description: "It'll never break!", price: 40, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 22)

      expect(@meg.average_item_price).to eq(70)
    end

    it 'distinct_cities' do
      chain = @meg.items.create(name: "Chain", description: "It'll never break!", price: 40, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 22)
      order_1 = create(:order, user: @user, address: create(:address, city: "Denver"))
      order_2 = create(:order, user: @user, address: create(:address, city: "Denver"))
      order_3 = create(:order, user: @user, address: create(:address, city: "Hershey"))

      @user.item_orders.create!(order: order_1, item: @tire, price: @tire.price, quantity: 2)
      @user.item_orders.create!(order: order_2, item: chain, price: chain.price, quantity: 2)
      @user.item_orders.create!(order: order_3, item: @tire, price: @tire.price, quantity: 2)

      expect(@meg.distinct_cities.sort).to eq(["Denver","Hershey"])
    end

    it 'activate_items' do
      merchant = create(:merchant)
      item = merchant.items.create(attributes_for(:item, active?: false))

      expect(item.active?).to be false

      merchant.activate_items

      expect(item.active?).to be true
    end

    it 'deactivate_items' do
      merchant = create(:merchant)
      item = merchant.items.create(attributes_for(:item, active?: true))

      expect(item.active?).to be true

      merchant.deactivate_items

      expect(item.active?).to be false
    end

    it "pending_orders" do
      order_1 = create(:order, user: @user, address: @address)
      item_order_1 = @user.item_orders.create!(order: order_1, item: @tire, price: @tire.price, quantity: 2)
      expect(@meg.pending_orders).to eq([order_1])
    end
  end
end
