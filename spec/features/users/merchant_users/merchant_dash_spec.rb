
require 'rails_helper'

RSpec.describe "Show Merchant Dashboard" do
  describe "As a merchant employee or admin" do
    before :each do
      @bike_shop = create(:merchant)

      @chain = create(:item, merchant: @bike_shop)
      @tire = create(:item, merchant: @bike_shop)
      @merchant_admin = create(:merchant_admin, merchant: @bike_shop)

    end

    it "When I visit my merchant dashboard, I see the name and full address of the merchant I work for" do
      visit "/login"

      fill_in :email, with: @merchant_admin.email
      fill_in :password, with: @merchant_admin.password

      click_button "Submit"

      expect(current_path).to eq(merchant_user_path)
      expect(page).to have_content(@bike_shop.name)
      expect(page).to have_content(@bike_shop.address)
      expect(page).to have_content("#{@bike_shop.city}, #{@bike_shop.state} #{@bike_shop.zip}")

    end

    it "When I visit my merchant dashboard, if any users have pending orders containing items I sell, then I see a list of these orders with order ID (linked to order show page), date the order was made, total quantity of my items in the order, and the total value of my items for that order" do
      user = create(:user)
      order_1 = create(:order)
      item_order_1 = user.item_orders.create!(order: order_1, item: @chain, quantity: 1, price: @chain.price)
      item_order_2 = user.item_orders.create!(order: order_1, item: @tire, quantity: 1, price: @tire.price)

      visit login_path

      fill_in "Email", with: @merchant_admin.email
      fill_in "Password", with: @merchant_admin.password

      click_on "Submit"

      expect(current_path).to eq(merchant_user_path)
      within "#order-#{order_1.id}" do
        expect(page).to have_link("Order ##{order_1.id}")
        expect(page).to have_content(order_1.created_at.strftime('%D'))
        expect(page).to have_content(order_1.total_items)
        expect(page).to have_content(order_1.grandtotal)
      end
    end
  end
end
