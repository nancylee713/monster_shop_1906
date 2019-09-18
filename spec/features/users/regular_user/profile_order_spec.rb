require 'rails_helper'

RSpec.describe "User Profile Order Page" do
  before :each do
    @user = create(:user)
    address_1 = @user.addresses.create!(attributes_for(:address, id: 1))
    address_2 = @user.addresses.create!(attributes_for(:address, id: 2))
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

    merchant_1 = create(:merchant)
    @item_1 = merchant_1.items.create!(attributes_for(:item))
    @item_2 = merchant_1.items.create!(attributes_for(:item))

    @order_1 = create(:order, user: @user, address: address_1)
    @order_2 = create(:order, user: @user, address: address_2, status: 'packaged')
    @item_order_1 = @user.item_orders.create!(order: @order_1, item: @item_1, quantity: 1, price: @item_1.price)
    @item_order_2 = @user.item_orders.create!(order: @order_1, item: @item_2, quantity: 3, price: @item_2.price)
  end

  it "see a link to my orders" do
    visit profile_path

    expect(page).to have_link("My Orders")
    click_link("My Orders")
    expect(current_path).to eq("/profile/orders")
  end

  it "see a flash message confirming my recent order and empty cart" do
    visit item_path(@item_1)
    click_on "Add To Cart"

    visit "/cart"
    click_on "Checkout"

    fill_in "order_name", with: "Bert"
    find("option[value=1]").click

    click_on "Create Order"

    expect(current_path).to eq("/profile/orders")

    expect(page).to have_content("Your order has been created!")

    within 'nav' do
      expect(page).to have_content("Cart: 0")
    end
  end

  it "see a list of my orders and detailed order info" do
    visit "/profile/orders"

    within "#order-#{@order_1.id}" do
      expect(page).to have_link(@order_1.id)
      expect(page).to have_content(@order_1.created_at)
      expect(page).to have_content(@order_1.updated_at)
      expect(page).to have_content(@order_1.status)
    end

    within "#order-#{@order_1.id}" do
      expect(page).to have_content(@order_1.total_items)
      expect(page).to have_content("$#{@order_1.grandtotal}")
    end
  end

  it "can click an individual order id and see detailed info" do
    visit "/profile/orders"

    within "#order-#{@order_1.id}" do
      click_link(@order_1.id)
    end

    expect(current_path).to eq("/profile/orders/#{@order_1.id}")

    within "#order-#{@order_1.id}" do
      expect(page).to have_link(@order_1.id)
      expect(page).to have_content(@order_1.address.to_s)
      expect(page).to have_content(@order_1.created_at)
      expect(page).to have_content(@order_1.updated_at)
      expect(page).to have_content(@order_1.status)
    end

    within "#item-#{@item_1.id}" do
      expect(page).to have_content(@item_1.name)
      expect(page).to have_css("#thumbnail-#{@item_1.id}")
      expect(page).to have_content(@item_1.description)
      expect(page).to have_content(@item_1.price)
      expect(page).to have_content(@item_order_1.quantity)
      expect(page).to have_content(@item_order_1.subtotal)
    end
  end

  it "I can cancel the order only if it's pending" do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
    visit "/profile/orders/#{@order_1.id}"

    expect(page).to have_link("Cancel Order")

    click_link "Cancel Order"

    expect(current_path).to eq(profile_path)
    expect(page).to have_content("Your order has been cancelled")

    visit "/profile/orders/#{@order_1.id}"

    expect(page).to have_content("cancelled")

    visit "/profile/orders/#{@order_2.id}"

    expect(page).not_to have_link("Cancel Order")
  end
end
