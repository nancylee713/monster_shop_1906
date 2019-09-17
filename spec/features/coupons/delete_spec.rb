require 'rails_helper'

RSpec.describe "Coupon Deletion" do
  describe "As Merchant Admin" do
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

    it "I can click a link to delete each coupon" do
      coupon = @bike_shop.coupons.create!(name: "29L7TK7QZE", value: 3, is_percent: false, item_id: @tire.id)

      visit merchant_coupons_path

      within "#coupon-#{coupon.id}" do
        click_link("Delete")
      end

      expect(current_path).to eq(merchant_coupons_path)
      expect(page).to have_content("Your coupon is now deleted!")

      expect(page).to_not have_css("#coupon-#{coupon.id}")
    end

    it "I cannot delete a coupon that has been used" do
      user = create(:user)
      coupon = @bike_shop.coupons.create!(name: "29L7TK7QZE", value: 3, is_percent: false, item_id: @tire.id, user: user)

      user_2 = create(:user)
      coupon_2 = @bike_shop.coupons.create!(name: "30L7TK7QZE", value: 3, is_percent: false, item_id: @tire.id, user: user_2, is_redeemed: true)

      visit merchant_coupons_path

      within "#coupon-#{coupon.id}" do
        click_link("Delete")
      end

      expect(page).to_not have_css("#coupon-#{coupon.id}")

      within "#coupon-#{coupon_2.id}" do
        click_link("Delete")
      end

      expect(page).to have_content("This coupon has been already redeemed and cannot be deleted")
      expect(page).to have_css("#coupon-#{coupon_2.id}")
    end
  end
end
