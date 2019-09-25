require 'rails_helper'

RSpec.describe 'Cart show' do
  describe 'When I have added items to my cart' do
    before(:each) do
      @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)

      @regular_user = create(:user)
      @default_address = @regular_user.addresses.create(attributes_for(:address, nickname: 'default'))
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@regular_user)

      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
      @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
      visit item_path(@paper)
      click_on "Add To Cart"
      visit item_path(@tire)
      click_on "Add To Cart"
      visit item_path(@pencil)
      click_on "Add To Cart"
      @items_in_cart = [@paper,@tire,@pencil]
    end

    it 'Theres a link to checkout' do
      visit "/cart"

      expect(page).to have_link("Checkout")

      click_on "Checkout"

      expect(current_path).to eq('/profile/orders/new')
    end

    describe "When I delete all addresses I cannot checkout" do
      it "and I see an error telling me I need to add an address first" do
        @regular_user.addresses.delete(@default_address)

        visit "/cart"

        click_link("Checkout")

        expect(page).to have_content("There is currently no shipping address available. Please add a new address to proceed to checkout")
        expect(current_path).to eq(new_profile_address_path)
      end
    end
  end

  describe 'When I havent added items to my cart' do
    it 'There is not a link to checkout' do
      visit "/cart"

      expect(page).to_not have_link("Checkout")
    end
  end
end
