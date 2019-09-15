require 'rails_helper'

RSpec.describe 'Site Navigation' do
  describe 'As a Visitor' do
    it "I see a nav bar with links to all pages" do
      visit merchants_path

      within 'nav' do
        click_link 'All Items'
      end

      expect(current_path).to eq(items_path)

      within 'nav' do
        click_link 'All Merchants'
      end

      expect(current_path).to eq(merchants_path)
    end

    it "I can see a cart indicator on all pages and click link" do
      regular_user = create(:user)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(regular_user)

      visit merchants_path

      within 'nav' do
        expect(page).to have_link("Cart: 0")
        click_link("Cart: 0")
      end

      expect(current_path).to eq("/cart")

      visit items_path

      within 'nav' do
        expect(page).to have_link("Cart: 0")
      end
    end

    it 'can return to the welcome / home page of the application' do
      visit merchants_path

      within 'nav' do
        click_link('Home')
      end

      expect(current_path).to eq(root_path)
    end

    it 'I can click login link' do
      visit root_path

      within 'nav' do
        click_link('Login')
      end

      expect(current_path).to eq('/login')
    end

    it 'I can click on registration link' do
      visit root_path

      within 'nav' do
        click_link('Register')
      end

      expect(current_path).to eq('/register')
    end
  end

  describe "As a Registered User" do
    it "I see profile and logout links but not login and register links on navigation bar" do
      regular_user = create(:user)

      visit '/login'

      within 'nav' do
        click_link('Login')
      end

      fill_in :email, with: regular_user.email
      fill_in :password, with: regular_user.password

      click_button "Submit"

      expect(current_path).to eq('/profile')

      within 'nav' do
        expect(page).to have_link("Logout")
        expect(page).to have_link("Profile")

        expect(page).to_not have_link("Login")
        expect(page).to_not have_link("Register")
      end

      expect(page).to have_content("Logged in as #{regular_user.name}")
    end
  end

  describe "As an Admin User" do
    it "I see appropriate links in the nav bar" do
      admin_user = create(:admin)

      visit '/login'

      within 'nav' do
        click_link('Login')
      end

      fill_in :email, with: admin_user.email
      fill_in :password, with: admin_user.password

      click_button "Submit"

      visit items_path

      within 'nav' do
        expect(page).to have_link("Logout")
        expect(page).to have_link("Profile")
        expect(page).to have_link("All Users")
        expect(page).to have_link("Admin Dashboard")


        expect(page).to_not have_link("Login")
        expect(page).to_not have_link("Register")
        expect(page).to_not have_link("Cart: 0")
      end
    end
  end

  describe "As a Merchant Employee/Admin" do
      before :each do
        @bike_shop = create(:merchant)
        @merchant_employee = create(:merchant_employee, merchant: @bike_shop)
        @merchant_admin = create(:merchant_admin, merchant: @bike_shop)
      end

      it "I see profile, logout, and merchant dashboard links on navigation bar" do
        visit '/login'

        within 'nav' do
          click_link('Login')
        end

        fill_in :email, with: @merchant_admin.email
        fill_in :password, with: @merchant_admin.password

        click_button "Submit"

        expect(current_path).to eq('/merchant')

        within 'nav' do
          expect(page).to have_link("Logout")
          expect(page).to have_link("Profile")
          expect(page).to have_link("Merchant Dashboard")
          expect(page).to_not have_link("Login")
          expect(page).to_not have_link("Register")
        end

        expect(current_path).to eq('/merchant')
        expect(page).to have_content("Logged in as #{@merchant_admin.name}")

        click_link "Logout"

        visit '/login'

        within 'nav' do
          click_link('Login')
        end

        fill_in :email, with: @merchant_employee.email
        fill_in :password, with: @merchant_employee.password

        click_button "Submit"

        expect(current_path).to eq('/merchant')

        within 'nav' do
          expect(page).to have_link("Logout")
          expect(page).to have_link("Profile")
          expect(page).to have_link("Merchant Dashboard")
          expect(page).to_not have_link("Login")
          expect(page).to_not have_link("Register")
        end

        expect(current_path).to eq('/merchant')
        expect(page).to have_content("Logged in as #{@merchant_employee.name}")
      end

      it "I get a 404 error when I try to access /admin paths" do
        visit admin_path
        expect(page).to have_content("The page you were looking for doesn't exist (404)")
      end
    end
end
