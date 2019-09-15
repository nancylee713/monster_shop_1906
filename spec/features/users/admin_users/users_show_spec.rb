require 'rails_helper'

RSpec.describe "Admin_user User Index Page " do
  before :each do
    @admin_user = create(:admin)
    @regular_user = create(:user)
    @merchant_admin = create(:merchant_admin)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin_user)
  end

  it "displays pertinent info for the specified user" do
    visit admin_users_path

    click_link(@regular_user.name)

    expect(current_path).to eq(admin_user_path(@regular_user))

    within "#user-info-#{@regular_user.id}" do
      expect(page).to have_content(@regular_user.name)
      expect(page).to have_content(@regular_user.default_address)
      expect(page).to have_content(@regular_user.email)
    end

    expect(page).to_not have_link("Edit Profile")

    visit admin_users_path

    click_link(@merchant_admin.name)

    expect(current_path).to eq(admin_user_path(@merchant_admin))

    within "#user-info-#{@merchant_admin.id}" do
      expect(page).to have_content(@merchant_admin.name)
      expect(page).to have_content(@merchant_admin.default_address)
      expect(page).to have_content(@merchant_admin.email)
    end

    expect(page).to_not have_link("Edit Profile")
  end
end
