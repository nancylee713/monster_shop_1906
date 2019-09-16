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
      address = @regular_user.addresses.create!(attributes_for(:address, id: 1))


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
      fill_in "Name", with: "Bert"
      find("option[value=1]").click

      click_button "Create Order"

      new_order = Order.last

      expect(current_path).to eq("/profile/orders")
    end

    it "I can add a new address on the order form" do
      name = "Bert"

      fill_in "Name", with: name

      click_link "Add a new address"

      street = "123 Sesame St"
      city = "Boston"
      state = "MA"
      zipcode = "02101"
      nickname = "home"

      fill_in "street", with: street
      fill_in "city", with: city
      fill_in "state", with: state
      fill_in "zipcode", with: zipcode
      fill_in "nickname", with: nickname

      click_on "Create Address"

      expect(current_path).to eq(profile_path)
      # how to redirect back to order page after filling out the form? conditional redirects?
    end

    it "once the order is complete, cart info is saved to item_orders table" do
      fill_in "Name", with: "Bert"
      find("option[value=1]").click

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
