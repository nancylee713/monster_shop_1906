require 'rails_helper'

RSpec.describe "Address creation" do
  before(:each) do
    user = create(:user)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    visit profile_path
  end

  describe "When I visit my profile page" do
    it "I see a link to add new address" do
      expect(page).to have_link("Add New Address")

      click_link "Add New Address"

      expect(current_path).to eq(profile_addresses_new_path)
    end
  end

  describe "When I click on a link to add new address" do
    it "I can create a new address" do

      street = "123 Sesame St"
      city = "Boston"
      state = "MA"
      zipcode = "02101"
      nickname = "home"

      click_link "Add New Address"

      fill_in "street", with: street
      fill_in "city", with: city
      fill_in "state", with: state
      fill_in "zipcode", with: zipcode
      fill_in "nickname", with: nickname

      click_on "Create Address"

      new_address = Address.last

      expect(current_path).to eq(profile_path)

      within "#address-#{new_address.id}" do
        expect(page).to have_content(street)
        expect(page).to have_content(city)
        expect(page).to have_content(state)
        expect(page).to have_content(zipcode)
        expect(page).to have_content(nickname)
      end
    end

    it "I cannot create a new address unless I complete the whole form" do

      street = "123 Sesame St"
      nickname = "work"

      click_link "Add New Address"

      fill_in "street", with: street
      fill_in "nickname", with: nickname

      click_on "Create Address"

      expect(page).to have_content("City can't be blank, State can't be blank, and Zipcode can't be blank")
      expect(current_path).to eq(profile_addresses_new_path)
    end
  end
end
