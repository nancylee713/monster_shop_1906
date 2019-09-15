require 'rails_helper'

RSpec.describe "Admin_user Merchant Index Page " do
  it "shows all merchants with pertinent info and links to individual merchants" do
    merchant_1 = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 80203)
    merchant_2 = Merchant.create(name: "Meg's Dog Shop", address: '123 Dog Rd.', city: 'Hershey', state: 'PA', zip: 80203, enabled?: false)

    admin_user = create(:admin)

    item_1 = merchant_1.items.create!(attributes_for(:item))
    item_2 = merchant_1.items.create!(attributes_for(:item))

    visit "/login"

    fill_in :email, with: admin_user.email
    fill_in :password, with: admin_user.password

    click_button "Submit"

    visit merchants_path

    within "#merchant-#{merchant_1.id}" do
      expect(page).to have_link(merchant_1.name)
      expect(page).to have_content(merchant_1.city)
      expect(page).to have_content(merchant_1.state)
      expect(page).to have_link("Disable")
    end

    within "#merchant-#{merchant_2.id}" do
      expect(page).to have_content(merchant_2.city)
      expect(page).to have_content(merchant_2.state)
      expect(page).to have_link("Enable")
      click_link(merchant_2.name)
    end

    expect(current_path).to eq(admin_merchant_path(merchant_2))
  end

  it "has a button that disables/enables merchants" do
    admin_user = create(:user, role: 3)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin_user)

    merchant_1 = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 80203)
    merchant_2 = Merchant.create(name: "Meg's Dog Shop", address: '123 Dog Rd.', city: 'Hershey', state: 'PA', zip: 80203, enabled?: false)

    item_1 = merchant_1.items.create!(attributes_for(:item))
    item_2 = merchant_1.items.create!(attributes_for(:item))

    visit merchants_path
    within "#merchant-#{merchant_1.id}" do
      expect(page).to have_content("Current status: enabled")
      click_link("Disable")
    end

    expect(current_path).to eq(merchants_path)
    expect(page).to have_content("#{merchant_1.name} is now disabled")

    within "#merchant-#{merchant_1.id}" do
      expect(page).to have_content("Current status: disabled")
      click_link("Enable")
    end

    expect(current_path).to eq(merchants_path)
    expect(page).to have_content("#{merchant_1.name} is now enabled")
  end

  it "deactivates/activates all merchant items when the merchant is disabled/enabled" do
    admin_user = create(:user, role: 3)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin_user)

    merchant_1 =  create(:merchant)
    merchant_2 =  create(:merchant, enabled?: false)

    item_1 = merchant_1.items.create!(attributes_for(:item))
    item_2 = merchant_1.items.create!(attributes_for(:item))

    visit items_path

    expect(page).to have_content(item_1.name)
    expect(page).to have_content(item_2.name)

    visit merchants_path

    within "#merchant-#{merchant_1.id}" do
      click_link("Disable")
    end

    visit items_path

    expect(page).to_not have_content(item_1.name)
    expect(page).to_not have_content(item_2.name)

    visit merchants_path

    within "#merchant-#{merchant_1.id}" do
      click_link("Enable")
    end

    visit items_path

    expect(page).to have_content(item_1.name)
    expect(page).to have_content(item_2.name)
  end
end
