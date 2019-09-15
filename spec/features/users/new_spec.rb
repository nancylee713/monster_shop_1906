require 'rails_helper'

RSpec.describe "Registering User" do
  before(:each) do
    @user_name = "Larry Pug"
    @user_email = "larrypug@email.com"
    @user_password = "password123"
    @user_confirm_password = "password123"
    @street = "123 Sesame St"
    @city = "Denver"
    @state = "CO"
    @zipcode = "80222"
    @nickname = "home"
  end

  it "creates new user" do
    visit "/register"

    fill_in "name", with: @user_name
    fill_in "email", with: @user_email
    fill_in "password", with: @user_password
    fill_in "password_confirmation", with: @user_confirm_password
    fill_in "street", with: @street
    fill_in "city", with: @city
    fill_in "state", with: @state
    fill_in "zipcode", with: @zipcode
    fill_in "nickname", with: @nickname

    click_on "Create User"

    expect(current_path).to eq("/profile")
    expect(page).to have_content("Welcome #{@user_name}! You are now registered and logged in.")
    expect(page).to have_content("Hello, #{@user_name}!")
    expect(page).to_not have_link("Login")
    expect(page).to_not have_link("Register")
  end

  it "when I visit the user registration page and do not fill in the form completely, I am returned to the registration page and see a flash message that I am missing required fields" do

    visit "/register"

    click_on "Create User"

    expect(current_path).to eq("/register")
    expect(page).to have_content("Password can't be blank, Name can't be blank, Email can't be blank, Email is invalid, Password confirmation doesn't match Password, Addresses street can't be blank, Addresses city can't be blank, Addresses state can't be blank, and Addresses zipcode can't be blank")
  end

  it "confirms passwords match" do
    visit "/register"

    user_password = "password123"
    user_confirm_password = "password456"

    fill_in "name", with: @user_name
    fill_in "email", with: @user_email
    fill_in "password", with: user_password
    fill_in "password_confirmation", with: user_confirm_password
    fill_in "street", with: @street
    fill_in "city", with: @city
    fill_in "state", with: @state
    fill_in "zipcode", with: @zipcode
    fill_in "nickname", with: @nickname


    click_on "Create User"

    expect(page).to have_content("Password confirmation doesn't match")
  end

  it "doesn't allow duplicate email registrations and returns me to the registration page with a filled-out form, without saving my details and I see a flash message saying that email is already in use" do
    user = create(:user)

    visit "/register"

    fill_in "name", with: @user_name
    fill_in "email", with: user.email
    fill_in "password", with: @user_password
    fill_in "password_confirmation", with: @user_confirm_password
    fill_in "street", with: @street
    fill_in "city", with: @city
    fill_in "state", with: @state
    fill_in "zipcode", with: @zipcode
    fill_in "nickname", with: @nickname

    click_on "Create User"

    expect(page).to have_content("Email has already been taken")

    expect(find_field('name').value).to eq @user_name
    expect(find_field('street').value).to eq @street
    expect(find_field('city').value).to eq @city
    expect(find_field('state').value).to eq @state
    expect(find_field('zipcode').value).to eq @zipcode
    expect(find_field('email').value).to eq nil
    expect(find_field('password').value).to eq nil
  end
end
