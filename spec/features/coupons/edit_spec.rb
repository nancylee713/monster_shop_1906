require 'rails_helper'

RSpec.describe "Coupon Edit" do
  describe "As Merchant Admin" do
    describe "My coupon edit page" do
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

      it "I can click a link to edit new coupon" do
        coupon = @bike_shop.coupons.create!(name: "29L7TK7QZE", value: 3, is_percent: false, item_id: @tire.id)

        visit merchant_coupons_path

        within "#coupon-#{coupon.id}" do
          click_link("Edit")
        end

        expect(current_path).to eq(edit_merchant_coupon_path(coupon))

        expect(find_field("Name").value.length).to eq(10)
        expect(find_field("Value").value).to eq("#{coupon.value}")
        expect(find_by_id('coupon_item_id').value).to eq(@tire.id.to_s)

        fill_in "Value", with: 5

        click_on "Update Coupon"

        binding.pry
        
        expect(current_path).to eq(merchant_coupons_path)
        expect(page).to have_content("Your coupon is updated!")


        within "#coupon-#{new_coupon.id}" do
          expect(page).to have_content(new_coupon.id)
          expect(page).to have_content(name)
          expect(page).to have_content("$#{value.to_f}")
          expect(page).to have_content(@tire.name)
          expect(page).to have_content(new_coupon.is_enabled)
        end
      end
    end
  end
end
