require 'rails_helper'

RSpec.describe "Merchant Users" do
  before :each do
    @merchant_admin = create(:merchant_admin)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_admin)
  end

  it "cannot access admin paths" do
    visit admin_path
    expect(page).to have_content("The page you were looking for doesn't exist.")

    visit admin_users_path
    expect(page).to have_content("The page you were looking for doesn't exist.")
  end
end
