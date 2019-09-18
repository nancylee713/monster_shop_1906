require 'rails_helper'

RSpec.describe("New Order Page") do
  describe "When I check out from my cart" do
    before(:each) do
      @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
      @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
      @regular_user = create(:user)
      @address = @regular_user.addresses.create(attributes_for(:address))

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@regular_user)

      visit item_path(@paper)
      click_on "Add To Cart"
      visit item_path(@paper)
      click_on "Add To Cart"
      visit item_path(@tire)
      click_on "Add To Cart"
      visit item_path(@pencil)
      click_on "Add To Cart"
    end

    it "I see all the information about my current cart" do
      visit "/cart"

      click_on "Checkout"

      within "#order-item-#{@tire.id}" do
        expect(page).to have_link(@tire.name)
        expect(page).to have_link("#{@tire.merchant.name}")
        expect(page).to have_content("$#{@tire.price}")
        expect(page).to have_content("1")
        expect(page).to have_content("$100")
      end

      within "#order-item-#{@paper.id}" do
        expect(page).to have_link(@paper.name)
        expect(page).to have_link("#{@paper.merchant.name}")
        expect(page).to have_content("$#{@paper.price}")
        expect(page).to have_content("2")
        expect(page).to have_content("$40")
      end

      within "#order-item-#{@pencil.id}" do
        expect(page).to have_link(@pencil.name)
        expect(page).to have_link("#{@pencil.merchant.name}")
        expect(page).to have_content("$#{@pencil.price}")
        expect(page).to have_content("1")
        expect(page).to have_content("$2")
      end

      within "#order-grandtotal" do
        expect(page).to have_content("$142.00")
      end
    end

    it "I see a form where I can enter my shipping info" do
      visit "/cart"
      click_on "Checkout"

      expect(page).to have_field("order_name")
      expect(page).to have_css(".address_dropdown")
      expect(page).to have_link("Add a new address")
      expect(page).to have_button("Create Order")
    end

    it "Once I submit my order I am redirected to my profile order page that displays my order info" do
      visit "/cart"
      click_on "Checkout"

      fill_in "order_name", with: "John"
      find("option[value=#{@address.id}]").click
      click_button "Create Order"

      new_order = Order.last

      expect(current_path).to eq(profile_orders_path)
      expect(page).to have_content("Your order has been created!")
      expect(page).to have_content(new_order.id)
      expect(page).to have_content(new_order.address)
    end

    it "I see a form where I can select a coupon for specific item" do
      visit "/cart"
      click_on "Checkout"

      expect(page).to have_css(".user_coupon_dropdown")
      expect(page).to have_button("Apply")
    end

    it "When I click apply button I see an updated order total price" do
      user = create(:user)
      address = user.addresses.create(attributes_for(:address))
      merchant = create(:merchant)
      item = merchant.items.create(attributes_for(:item, price: 100))
      order = create(:order, user: user, address: address)
      item_order = ItemOrder.create!(order: order, item: item, quantity: 1, price: item.price, user: user)
      coupon_1 = create(:coupon, value: 5, is_percent: false, merchant: merchant, item_id: item.id, user: user)

      cart = Cart.new({"#{item.id}"=>1})

      discounted = item_order.subtotal - coupon_1.value

      visit "/cart"
      click_on "Checkout"

      click_button "Apply"

      expect(current_path).to eq("profile/orders/coupon")
      expect(page).to have_content("Discounted Total: $#{discounted}")
    end
  end
end
