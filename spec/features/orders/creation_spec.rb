require 'rails_helper'

RSpec.describe("Order Creation") do
  describe "When I check out from my cart" do
    before(:each) do
      @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
      @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)

      @regular_user = create(:user)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@regular_user)

      visit item_path(@paper)
      click_on "Add To Cart"
      visit item_path(@paper)
      click_on "Add To Cart"
      visit item_path(@tire)
      click_on "Add To Cart"
      visit item_path(@pencil)
      click_on "Add To Cart"

      visit "/cart"
      click_on "Checkout"
    end

    it 'I can create a new order' do
      name = "Bert"
      address = create(:address, id: 1)

      fill_in "Name", with: name
      select "1", :from => "order[address_id]"

      click_button "Create Order"

      new_order = Order.last

      expect(current_path).to eq("/profile/orders")
    end

    it "once the order is complete, cart info is saved to item_orders table" do
      name = "Bert"
      address = create(:address, id: 2)

      fill_in "Name", with: name
      select "2", :from => "order[address_id]"

      click_button "Create Order"

      new_order = Order.last
      new_item_order = ItemOrder.last

      expect(new_item_order.order_id).to eq(new_order.id)
    end

    it 'i cant create order if info not filled out' do

      fill_in "Name", with: ""

      click_button "Create Order"

      expect(page).to have_content("Please complete address form to create an order.")
      expect(page).to have_button("Create Order")
    end
  end
end
