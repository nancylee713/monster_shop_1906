require 'rails_helper'

RSpec.describe "Merchant Items Page" do
  describe "As a merchant admin" do
    before :each do
      @shop = create(:merchant)
      @item_1 = create(:item, name: "apple", merchant: @shop)
      @item_2 = create(:item, name: "orange", merchant: @shop)

      user = create(:user)
      order = create(:order)
      item_order = user.item_orders.create!(order: order, item: @item_1, quantity: 1, price: @item_1.price)

      merchant_admin = create(:merchant_admin, merchant: @shop)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_admin)
      visit merchant_user_index_path
    end

    describe "I can add a new item" do
      it "when I click a link to add a new item, I see a new item form" do
        expect(page).to have_link("Add New Item")

        click_link("Add New Item")

        expect(current_path).to eq(new_merchant_user_path)
      end

      describe "When I submit valid information" do
        describe "I am taken back to my items page and see a success flash message" do
          it "I see the new item on the page, and it is enabled and available for sale" do
            visit new_merchant_user_path

            name = "Chamois Buttr"
            price = 18
            description = "No more chaffin'!"
            image_url = "https://images-na.ssl-images-amazon.com/images/I/51HMpDXItgL._SX569_.jpg"
            inventory = 25

            fill_in "Name", with: name
            fill_in "Price", with: price
            fill_in "Description", with: description
            fill_in "Image", with: image_url
            fill_in "Inventory", with: inventory

            click_button "Create Item"

            expect(current_path).to eq(merchant_user_index_path)
            expect(page).to have_content("Your new item is saved!")
            expect(page).to have_content(name)
            expect(page).to have_content(description)
            expect(page).to have_content("$#{price}")
            expect(page).to have_css("img[src*='#{image_url}']")
            expect(page).to have_content(inventory)
            expect(page).to have_content("Active")  # how to check contents for enabled? and active? they need to be more specfic
          end
        end
      end

      describe "When I submit invalid information" do
        it "I see an error flash message for certain fields" do
          visit new_merchant_user_path

          fill_in "Price", with: -5
          fill_in "Image", with: ""
          fill_in "Inventory", with: -5

          click_button "Create Item"

          expect(page).to have_content("Name can't be blank")
          expect(page).to have_content("Description can't be blank")
          expect(page).to have_content("Price must be greater than 0")
          expect(page).to have_content("Inventory must be greater than or equal to 0")
          expect(page).to_not have_content("Image can't be blank")
        end
      end

      describe "If I left the image field blank" do
        it "I see a placeholder image for the thumbnail" do
          visit new_merchant_user_path

          name = "Chamois Buttr"
          price = 18
          description = "No more chaffin'!"
          inventory = 25

          fill_in "Name", with: name
          fill_in "Price", with: price
          fill_in "Description", with: description
          fill_in "Image", with: ""
          fill_in "Inventory", with: inventory

          click_button "Create Item"

          expect(current_path).to eq(merchant_user_index_path)
          expect(page).to have_css("img[src*='https://avatars3.githubusercontent.com/u/6475745?s=88&v=4']")
        end
      end
    end
  end
end
