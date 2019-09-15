require 'rails_helper'

RSpec.describe 'Address delete', type: :feature do
  before(:each) do
    user = User.create!(name: 'user-1', email: 'email-1@email.com', password: 'password')
    @home_address = user.addresses.create!(street: 'street-1', city: 'Denver', state: 'CO', zipcode: '80202', nickname: 'home')
    @dorm_address = user.addresses.create!(street: 'street-2', city: 'Denver', state: 'CO', zipcode: '80202', nickname: 'dorm')
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
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
  end
end
