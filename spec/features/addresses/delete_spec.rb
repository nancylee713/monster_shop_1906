require 'rails_helper'

RSpec.describe 'Address delete', type: :feature do
  before(:each) do
    @user = User.create!(name: 'user-1', email: 'email-1@email.com', password: 'password')
    @home_address = @user.addresses.create!(id: 1, street: 'street-1', city: 'Denver', state: 'CO', zipcode: '80202', nickname: 'home')
    @dorm_address = @user.addresses.create!(id: 2, street: 'street-2', city: 'Denver', state: 'CO', zipcode: '80202', nickname: 'dorm')
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
    visit profile_path
  end

  describe "when I visit the user profile page" do
    it "and click a link to delete an address I no longer see that address in profile page" do
      within "#address-#{@home_address.id}" do
        expect(page).to have_link("Delete")
        click_link "Delete"
      end

      expect(current_path).to eq(profile_path)
      expect(page).to have_content("Your #{@home_address.nickname} address is now deleted!")
      expect(page).to_not have_css("#address-#{@home_address.id}")
    end

    it "an address cannot be deleted or changed if it's been used in a 'shipped' order" do
      order_1 = create(:order, user: @user, address: @home_address)
      order_2 = create(:order, user: @user, address: @dorm_address, status: 2)

      within "#address-#{@home_address.id}" do
        click_link "Delete"
      end

      expect(page).to_not have_css("#address-#{@home_address.id}")

      within "#address-#{@dorm_address.id}" do
        click_link "Delete"
      end

      expect(page).to have_content("This address has been already used in a shipped order and cannot be deleted at this time.")
      expect(page).to have_css("#address-#{@dorm_address.id}")
    end
  end
end
