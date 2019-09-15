require 'rails_helper'

RSpec.describe "Admin_user User Index Page " do
  before :each do
    @admin_user = create(:admin)
    @regular_user = create(:user)
    @merchant_admin = create(:merchant_admin)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin_user)
  end

  it "displays pertinent info for all users" do
    visit merchants_path

    within 'nav' do
      click_link "All Users"
    end

    expect(current_path).to eq(admin_users_path)

    within "#user-#{@admin_user.id}" do
      expect(page).to have_link(@admin_user.name)
      expect(page).to have_content(@admin_user.created_at.strftime("%Y-%m-%d"))
      expect(page).to have_content(@admin_user.role)
    end

    within "#user-#{@regular_user.id}" do
      expect(page).to have_link(@regular_user.name)
      expect(page).to have_content(@regular_user.created_at.strftime("%Y-%m-%d"))
      expect(page).to have_content(@regular_user.role)
    end
    within "#user-#{@merchant_admin.id}" do
      expect(page).to have_link(@merchant_admin.name)
      expect(page).to have_content(@merchant_admin.created_at.strftime("%Y-%m-%d"))
      expect(page).to have_content(@merchant_admin.role)
    end
  end
end
