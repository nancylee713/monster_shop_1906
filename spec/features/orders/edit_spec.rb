require 'rails_helper'

RSpec.describe "User Profile Order Page" do
  before :each do
    @user = create(:user)
    address_1 = @user.addresses.create!(attributes_for(:address, id: 1))
    address_2 = @user.addresses.create!(attributes_for(:address, id: 2))
    # allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

    visit "/login"
    fill_in :email, with: @user.email
    fill_in :password, with: @user.password
    click_button "Submit"

    merchant_1 = create(:merchant)
    item_1 = merchant_1.items.create!(attributes_for(:item))
    item_2 = merchant_1.items.create!(attributes_for(:item))

    @order_1 = create(:order, user: @user, address: address_1, status: 'pending')
    @order_2 = create(:order, user: @user, address: address_2, status: 'packaged')
    @item_order_1 = @user.item_orders.create!(order: @order_1, item: item_1, quantity: 1, price: item_1.price)
    @item_order_2 = @user.item_orders.create!(order: @order_2, item: item_2, quantity: 3, price: item_2.price)

    visit "/profile/orders"
  end

  describe "After checking out my order, if an order is still pending" do
    it "I can change to a different address I want my items shipped " do
      within "#order-#{@order_2.id}" do
        click_link(@order_2.id)
      end

      expect(page).to_not have_link("Update Shipping Address")

      visit "/profile/orders"

      within "#order-#{@order_1.id}" do
        click_link(@order_1.id)
      end

      expect(page).to have_link("Update Shipping Address")

      click_link "Update Shipping Address"

      expect(find_field("street").value).to eq(@order_1.address.street)

      new_street = "new street"
      fill_in "street", with: new_street

      click_button "Update Address"

      expect(current_path).to eq("/profile/orders/#{@order_1.id}")
      expect(page).to have_content("Your shipping address has been updated!")

      within "#order-#{@order_1.id}" do
        expect(page).to have_content(new_street)
      end
    end
  end
end
