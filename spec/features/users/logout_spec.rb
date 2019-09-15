
require 'rails_helper'

RSpec.describe "User Logout" do
  before :each do
    @user = create(:user)
    @mike = create(:merchant, name: "Mike Shop")
    @paper = create(:item, merchant: @mike)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
  end

  it "can logout user and redirect to the home page with a flash messages indicating that I am logged out and all shopping cart items are deleted" do
    visit item_path(@paper)
      click_on "Add To Cart"

    within 'nav' do
      click_link 'Logout'
    end

    expect(current_path).to eq(root_path)
    expect(page).to have_content("You have been logged out!")
    expect(page).to have_content("Cart: 0")
  end
end
