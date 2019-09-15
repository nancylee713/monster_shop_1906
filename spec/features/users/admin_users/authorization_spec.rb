require 'rails_helper'

RSpec.describe "Admin Users" do
  before :each do
    @admin_user = create(:admin)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin_user)
  end

  it "cannot access merchant or cart paths" do
    visit '/merchant'
    expect(page).to have_content("The page you were looking for doesn't exist.")

    visit '/cart'
    expect(page).to have_content("The page you were looking for doesn't exist.")
  end
end
