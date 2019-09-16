require 'rails_helper'

describe Item, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should allow_value(nil, "").for(:image) }
    it { should validate_numericality_of :price }
    it { should validate_numericality_of(:inventory).only_integer }
    it { should validate_inclusion_of(:active?).in_array([true,false]) }
  end

  describe "relationships" do
    it {should belong_to :merchant}
    it {should have_many :reviews}
    it {should have_many :item_orders}
    it {should have_many(:orders).through(:item_orders)}
  end

  describe "instance methods" do
    before(:each) do
      @user = create(:user)
      address_1 = create(:address)
      address_2 = create(:address)
      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @chain = @bike_shop.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)
      @bike = @bike_shop.items.create(name: "Bike", description: "You can ride it!", price: 200, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 0)
      @watch = @bike_shop.items.create(name: "Watch", description: "You can wear it!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 10)

      @review_1 = @chain.reviews.create(title: "Great place!", content: "They have great bike stuff and I'd recommend them to anyone.", rating: 5)
      @review_2 = @chain.reviews.create(title: "Cool shop!", content: "They have cool bike stuff and I'd recommend them to anyone.", rating: 4)
      @review_3 = @chain.reviews.create(title: "Meh place", content: "They have meh bike stuff and I probably won't come back", rating: 1)
      @review_4 = @chain.reviews.create(title: "Not too impressed", content: "v basic bike shop", rating: 2)
      @review_5 = @chain.reviews.create(title: "Okay place :/", content: "Brian's cool and all but just an okay selection of items", rating: 3)

      @order_1 = create(:order, user: @user, address: address_1, status: "pending")
      @order_2 = create(:order, user: @user, address: address_2, status: "pending")
        @item_order_1 = @user.item_orders.create!(order: @order_2, item: @watch, quantity: 2, price: @watch.price, user: @user, fulfilled?: false)
    end

    it "calculate average review" do
      expect(@chain.average_review).to eq(3.0)
    end

    it "sorts reviews" do
      top_three = @chain.sorted_reviews(3,:desc)
      bottom_three = @chain.sorted_reviews(3,:asc)

      expect(top_three).to eq([@review_1,@review_2,@review_5])
      expect(bottom_three).to eq([@review_3,@review_4,@review_5])
    end

    it 'no orders' do
      expect(@chain.no_orders?).to eq(true)

      @user.item_orders.create(order: @order_1, item: @chain, price: @chain.price, quantity: 2)
      expect(@chain.no_orders?).to eq(false)
    end

    it 'return a cannot fulfill message' do
      expect(@chain.cannot_fulfill_message).to eq("Cannot fulfill. Only #{@chain.inventory} remaining.")
      expect(@bike.cannot_fulfill_message).to eq("Cannot fulfill. There are no #{@bike.name} items remaining.")
    end

    it 'can decrease inventory' do
      @chain.decrease_inventory(@item_order_1)
      expect(@chain.inventory).to eq(3)
    end

    it "can increase inventory" do
      @chain.increase_inventory(@item_order_1)
      expect(@chain.inventory).to eq(7)
    end

    it "can toggle status" do
      expect(@chain.active?).to be true
      @chain.toggle_status
      expect(@chain.active?).to be false
    end
  end

  describe "top and bottom five" do
    it "shows an area with statistics of top/bottom 5 most/least popular items (by quantity purchased), plus that quantity" do
      shop = create(:merchant)
      item_1 = shop.items.create(attributes_for(:item, name: "apple"))
      item_2 = shop.items.create(attributes_for(:item, name: "orange"))
      item_3 = shop.items.create(attributes_for(:item, name: "banana"))
      item_4 = shop.items.create(attributes_for(:item, name: "pear"))
      item_5 = shop.items.create(attributes_for(:item, name: "lychee"))
      item_6 = shop.items.create(attributes_for(:item, name: "watermelon"))
      items = [item_1, item_2, item_3, item_4, item_5, item_6]

      user = create(:user)
      order_1 = create(:order)
      item_order_1 = user.item_orders.create!(order: order_1, item: item_6, quantity: 6, price: item_6.price)
      item_order_2 = user.item_orders.create!(order: order_1, item: item_5, quantity: 5, price: item_5.price)
      item_order_3 = user.item_orders.create!(order: order_1, item: item_4, quantity: 4, price: item_4.price)
      item_order_4 = user.item_orders.create!(order: order_1, item: item_3, quantity: 3, price: item_3.price)

      order_2 = create(:order)
      item_order_5 = user.item_orders.create!(order: order_2, item: item_6, quantity: 6, price: item_6.price)
      item_order_6 = user.item_orders.create!(order: order_2, item: item_1, quantity: 1, price: item_1.price)
      item_order_7 = user.item_orders.create!(order: order_2, item: item_2, quantity: 2, price: item_2.price)
      item_order_8 = user.item_orders.create!(order: order_2, item: item_3, quantity: 3, price: item_3.price)

      expect(Item.top_5.map { |item| item.name }).to eq([item_6.name, item_3.name, item_5.name, item_4.name, item_2.name])
      expect(Item.bottom_5.map { |item| item.name }).to eq([item_1.name, item_2.name, item_4.name, item_5.name, item_3.name])
    end
  end
end
