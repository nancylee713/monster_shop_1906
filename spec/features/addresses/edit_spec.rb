require 'rails_helper'

RSpec.describe 'Address edit and update', type: :feature do
  before(:each) do
    user = User.create!(name: 'user-1', email: 'email-1@email.com', password: 'password')
    @home_address = user.addresses.create!(street: 'street-1', city: 'Denver', state: 'CO', zipcode: '80202', nickname: 'home')
    @dorm_address = user.addresses.create!(street: 'street-2', city: 'Denver', state: 'CO', zipcode: '80202', nickname: 'dorm')
    # allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit "/login"

    fill_in :email, with: user.email
    fill_in :password, with: user.password

    click_button "Submit"
  end

  describe "when I visit the user profile page" do
    it "I see a link called Edit in each address card" do

      within "#address-#{@home_address.id}" do
        expect(page).to have_link("Edit")
        click_link "Edit"
      end

      expect(current_path).to eq("/profile/addresses/#{@home_address.id}/edit")
    end

    it "I see a form that is auto-filled and I can edit an address when I fill in all of the fields" do

      within "#address-#{@home_address.id}" do
        expect(page).to have_link("Edit")
        click_link "Edit"
      end

      expect(find_field("nickname").value).to eq(@home_address.nickname)
      expect(find_field("street").value).to eq(@home_address.street)
      expect(find_field("city").value).to eq(@home_address.city)
      expect(find_field("state").value).to eq(@home_address.state)
      expect(find_field("zipcode").value).to eq(@home_address.zipcode)

      fill_in "nickname", with: "new_nickname"
      click_on "Update Address"

      expect(current_path).to eq(profile_path)
      expect(page).to have_content("Your address is now updated!")

      within "#address-#{@home_address.id}" do
        expect(page).to have_content("new_nickname")
      end
    end

    it "I cannot update an address when I fill in just some of the fields" do
      within "#address-#{@home_address.id}" do
        expect(page).to have_link("Edit")
        click_link "Edit"
      end

      fill_in "street", with: ""
      fill_in "city", with: ""
      fill_in "state", with: "CO"
      fill_in "zipcode", with: "80202"
      fill_in "nickname", with: ""

      click_on "Update Address"

      expect(current_path).to eq("/profile/addresses/#{@home_address.id}")
      expect(page).to have_content("Street can't be blank, City can't be blank, and Nickname can't be blank")
    end
  end
end
