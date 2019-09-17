require 'rails_helper'

RSpec.describe "Coupon Status" do
  describe "As Merchant Admin" do
    describe "My coupon index page" do
      before(:each) do
        @bike_shop = create(:merchant)
        @tire = create(:item, merchant: @bike_shop)
        @merchant_admin = create(:merchant_admin, merchant: @bike_shop)

        visit login_path
        fill_in "Email", with: @merchant_admin.email
        fill_in "Password", with: @merchant_admin.password
        click_on "Submit"
      end

      it "a new coupon is enabled by default" do
        coupon = create(:coupon, merchant: @bike_shop, item_id: @tire.id)

        visit merchant_coupons_path

        within "#coupon-#{coupon.id}" do
          expect(page).to have_content("Enabled")
          expect(page).to have_link("Disable")
          expect(page).to_not have_link("Enable")
        end
      end

      it "I can disable a coupon and see a flash message" do
        coupon = create(:coupon, merchant: @bike_shop, item_id: @tire.id)

        visit merchant_coupons_path

        within "#coupon-#{coupon.id}" do
          click_link("Disable")
          expect(page).to have_content("Disabled")
          expect(page).to have_link("Enable")
        end

        expect(page).to have_content("This coupon is no longer valid")


        within "#coupon-#{coupon.id}" do
          click_link("Enable")
          expect(page).to have_content("Enabled")
          expect(page).to have_link("Disable")
        end

        expect(page).to have_content("This coupon is now available")
      end

      xit "a disabled coupon cannot be used by user during checkout" do

      end
    end
  end
end
