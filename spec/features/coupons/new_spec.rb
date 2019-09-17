require 'rails_helper'

RSpec.describe "Coupon creation" do
  describe "As Merchant Admin" do
    describe "My coupon index page" do
      before(:each) do
        @bike_shop = create(:merchant)

        @tire = create(:item, merchant: @bike_shop)
        @chain = create(:item, merchant: @bike_shop)
        @merchant_admin = create(:merchant_admin, merchant: @bike_shop)

        visit login_path
        fill_in "Email", with: @merchant_admin.email
        fill_in "Password", with: @merchant_admin.password
        click_on "Submit"
      end

      it "I can click a link to add new coupon" do
        visit merchant_coupons_path
        click_link("Add New Coupon")

        expect(current_path).to eq(new_merchant_coupon_path)

        fill_in "Value", with: 15
        find(:css, "#coupon_is_percent").set(false)
        find("option[value=#{@tire.id}]").click
        click_on "Create Coupon"

        expect(current_path).to eq(merchant_coupons_path)

        new_coupon = Coupon.last

        within "#coupon-#{new_coupon.id}" do
          expect(page).to have_content(new_coupon.id)
          expect(page).to have_content(new_coupon.name)
          expect(page).to have_content("$#{new_coupon.value.to_f}")
          expect(page).to have_content(@tire.name)
          expect(page).to have_content(new_coupon.is_enabled)
        end
      end

      it "I cannot create more than 5 coupons" do
        coupon_1 = create(:coupon, merchant: @bike_shop, item_id: @tire.id)
        coupon_2 = create(:coupon, merchant: @bike_shop, item_id: @tire.id)
        coupon_3 = create(:coupon, merchant: @bike_shop, item_id: @tire.id)
        coupon_4 = create(:coupon, merchant: @bike_shop, item_id: @tire.id)
        coupon_5 = create(:coupon, merchant: @bike_shop, item_id: @tire.id)

        visit merchant_coupons_path
        expect(page).to_not have_link("Add New Coupon")
      end
    end
  end
end
