require 'rails_helper'

RSpec.describe "Admin_user Merchant Show Page " do
  before :each do
    @bike_shop = Merchant.create!(name: "Brian's Bike Shop",
                address: '123 Bike Rd.',
                city: 'Richmond',
                state: 'VA',
                zip: 23137)

    @chain = @bike_shop.items.create!(name: "Chain",
              description: "It'll never break!",
              price: 50,
              image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588",
              inventory: 5)

    @tire = @bike_shop.items.create(name: "Gatorskins",
            description: "They'll never pop!",
            price: 100,
            image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588",
            inventory: 12)

    @admin_user = create(:admin)

    @user = create(:user)
    @order_1 = create(:order)
    @item_order_1 = @user.item_orders.create!(order: @order_1, item: @chain, quantity: 1, price: @chain.price)
    @item_order_2 = @user.item_orders.create!(order: @order_1, item: @tire, quantity: 1, price: @tire.price)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin_user)
  end

  it "has pertinent merchant info identical to the merchant dashboard" do
    visit admin_merchant_path(@bike_shop)

    expect(page).to have_content(@bike_shop.name)
    expect(page).to have_content(@bike_shop.address)
    expect(page).to have_content("#{@bike_shop.city}, #{@bike_shop.state} #{@bike_shop.zip}")

    within "#order-#{@order_1.id}" do
      expect(page).not_to have_link("Order ##{@order_1.id}")
      expect(page).to have_content("Order ##{@order_1.id}")
      expect(page).to have_content(@order_1.created_at.strftime('%D'))
      expect(page).to have_content(@order_1.total_items)
      expect(page).to have_content("$150")
    end
  end
end
