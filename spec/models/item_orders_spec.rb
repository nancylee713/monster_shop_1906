require 'rails_helper'

describe ItemOrder, type: :model do
  describe "validations" do
    it { should validate_presence_of :order_id }
    it { should validate_presence_of :item_id }
    it { should validate_presence_of :price }
    it { should validate_presence_of :quantity }
    it { should validate_inclusion_of(:fulfilled?).in_array([true, false])}
  end

  describe "relationships" do
    it {should belong_to :item}
    it {should belong_to :order}
    it {should belong_to :user}

  end

  describe 'instance methods' do
    it 'subtotal' do
      user = create(:user)
      meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      tire = meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      order_1 = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
      item_order_1 = user.item_orders.create!(order: order_1, item: tire, price: tire.price, quantity: 2)

      expect(item_order_1.subtotal).to eq(200)
    end
  end

  describe 'class methods' do
    before(:each) do
      user = create(:user)
      merchant_1 = create(:merchant)
      item_1 = merchant_1.items.create!(attributes_for(:item, inventory: 10, price: 10))
      item_2 = merchant_1.items.create!(attributes_for(:item, inventory: 4, price: 30))

      merchant_2 = create(:merchant)
      item_3 = merchant_2.items.create!(attributes_for(:item, inventory: 20))

      @order_1 = create(:order, status: "pending")
        @item_order_1 = user.item_orders.create!(order: @order_1, item: item_1, quantity: 1, price: item_1.price, fulfilled?: false)
        @item_order_2 = user.item_orders.create!(order: @order_1, item: item_2, quantity: 3, price: item_2.price, fulfilled?: false)

      @order_2 = create(:order, status: "pending")
        @item_order_3 = user.item_orders.create!(order: @order_2, item: item_3, quantity: 1, price: item_3.price, fulfilled?: false)
        @item_order_4 = user.item_orders.create!(order: @order_2, item: item_2, quantity: 10000, price: item_2.price, fulfilled?: false)
    end

    it 'total_quantity_per_order' do
      expect(ItemOrder.total_quantity_per_order(@order_1.id)).to eq(4)
    end

    it 'grandtotal_per_order' do
      expect(ItemOrder.grandtotal_per_order(@order_1.id)).to eq(100)
    end

    it 'can return true if item is in stock' do
      expect(@item_order_1.instock?).to eq(true)
      expect(@item_order_4.instock?).to eq(false)
    end

    it 'can update status to packaged' do
      @item_order_1.update_status

      expect(@item_order_1.fulfilled?).to eq(true)
    end

    it 'display_info' do
      info = ItemOrder.display_info(@order_1)

      expect(info.keys.include? @order_1.id).to eq(true)
      expect(info.values.flatten.count).to eq(2)
    end
  end
end
