require 'rails_helper'

RSpec.describe "User Profile" do
  before :each do
    @regular_user = create(:user)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@regular_user)
    visit '/profile'
  end

  it 'can edit user information' do

    within "#user-profile-actions" do
      click_link("Edit Profile")
    end

    expect(current_path).to eq("/profile/edit")

    fill_in "Name", with: "Adam Smith"
    fill_in "Email", with: "chicken@email.com"

    click_button "Update Profile"

    expect(current_path).to eq("/profile")
    expect(page).to have_content("Adam Smith")
    expect(page).to have_content("#{@regular_user.default_address}")
    expect(page).to have_content("chicken@email.com")
    expect(page).to have_content("Your profile has been updated")
  end

  it 'user cannot enter nil information' do

    within "#user-profile-actions" do
      click_link("Edit Profile")
    end

    fill_in "Name", with: "Adam Smith"
    fill_in "Email", with: ""

    click_button "Update Profile"

    expect(current_path).to eq("/profile/edit")
    expect(page).to have_content("Email can't be blank")
  end

  it 'user cannot enter invalid email' do
    within "#user-profile-actions" do
      click_link("Edit Profile")
    end

    fill_in "Name", with: "Adam Smith"
    fill_in "Email", with: "waffle"

    click_button "Update Profile"

    expect(current_path).to eq("/profile/edit")
    expect(page).to have_content("Email is invalid")
  end

  it "user can edit password" do
    expect(page).to have_link("")

    within "#user-profile-actions" do
      click_link("Edit Password")
    end

    expect(current_path).to eq("/profile/edit_password")

    fill_in "Password", with: ""
    fill_in "Password confirmation", with: "apple123"
    click_on "Update"

    expect(page).to have_content("Password confirmation doesn't match Password")

    fill_in "Password", with: "apple123"
    fill_in "Password confirmation", with: "apple123"
    click_on "Update"

    expect(current_path).to eq("/profile")
    expect(page).to have_content("Your password has been updated")

    click_link "Logout"

    visit '/login'

    fill_in :email, with: "junglegeorge@email.com"
    fill_in :password, with: "Tree123"
    click_on "Submit"

    expect(page).to have_content("Please enter valid user information")
  end
end
