
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
      visit login_path
      fill_in "Email", with: @merchant_admin.email
      fill_in "Password", with: @merchant_admin.password
      click_on "Submit"

      expect(current_path).to eq(merchant_user_path)
      expect(page).to have_content(@bike_shop.name)
      expect(page).to have_content(@bike_shop.address)
      expect(page).to have_content("#{@bike_shop.city}, #{@bike_shop.state} #{@bike_shop.zip}")
    end

    it "If any users have pending orders containing items I sell, then I see a list of these orders with detailed info" do
      user = create(:user)
      address = create(:address)
      order_1 = create(:order, user: user, address: address)
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

    it "When I click a link to manage coupons I am redirected to coupons index page" do
      visit login_path
      fill_in "Email", with: @merchant_admin.email
      fill_in "Password", with: @merchant_admin.password
      click_on "Submit"
      
      expect(page).to have_link("Manage My Coupons")
      click_link "Manage My Coupons"

      expect(current_path).to eq("/merchant/coupons")
    end
  end
end
