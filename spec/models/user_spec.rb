require 'rails_helper'

describe User, type: :model do
  describe "validations" do
    it {should validate_presence_of :name}
    it {should validate_presence_of :email}
    it {should validate_presence_of :password}
    it {should validate_confirmation_of(:password).on(:create)}

    it {should validate_uniqueness_of(:email).case_insensitive}
    it {should allow_value('user@example.com').for(:email)}
    it {should_not allow_value("foo").for(:email)}
  end

  describe "relationships" do
    it {should have_many :item_orders}
    it {should belong_to(:merchant).optional }
    it {should have_many :addresses }
    it {should accept_nested_attributes_for :addresses}
    it {should have_many :orders}
    it {should have_many :coupon_users}
    it {should have_many(:coupons).through(:coupon_users)}
  end

  describe "roles" do
    it "can be created as a default user" do
      regular_user = create(:user)
      expect(regular_user).to be_valid
      expect(regular_user.role).to eq("regular_user")
      expect(regular_user.regular_user?).to be_truthy
    end

    it "can be created as a merchant employee" do
      merchant_employee = create(:merchant_employee)
      expect(merchant_employee).to be_valid
      expect(merchant_employee.role).to eq("merchant_employee")
      expect(merchant_employee.merchant_employee?).to be_truthy
    end

    it "can be created as a merchant admin" do
      merchant_admin = create(:merchant_admin)
      expect(merchant_admin).to be_valid
      expect(merchant_admin.role).to eq("merchant_admin")
      expect(merchant_admin.merchant_admin?).to be_truthy
    end

    it "can be created as a admin user" do
      admin_user = create(:admin)
      expect(admin_user).to be_valid
      expect(admin_user.role).to eq("admin_user")
      expect(admin_user.admin_user?).to be_truthy
    end
  end

  describe "creating users with factory bot" do
    it "a new user must have a unique email" do
      user_1 = create(:user, email: "bob@gmail.com")
      user_2 = build(:user, email: "bob@gmail.com")
      expect(user_2).to_not be_valid
    end
  end

  describe "methods" do
    it 'can find item orders by merchant user with order id' do
      regular_user_1 = create(:user)

      merchant_shop_1 = create(:merchant)
        item_1 = merchant_shop_1.items.create!(attributes_for(:item, name: "Item 1" ))
        item_2 = merchant_shop_1.items.create!(attributes_for(:item, name: "Item 2"))

      order_1 = create(:order)
        item_order_1 = regular_user_1.item_orders.create!(order: order_1, item: item_1, quantity: 2, price: item_1.price, user: regular_user_1)
        item_order_2 = regular_user_1.item_orders.create!(order: order_1, item: item_2, quantity: 8, price: item_2.price, user: regular_user_1)

      order_2 = create(:order)
        item_order_4 = regular_user_1.item_orders.create(order: order_2, item: item_2, quantity: 18, price: item_2.price, user: regular_user_1)

      merchant_admin = create(:user, role: 2, merchant: merchant_shop_1)

      expected = [item_order_1, item_order_2]

      expect(expected).to eq(merchant_admin.item_orders_by_merchant(order_1))
    end

    it 'default_address' do
      user = create(:user)
      default_address = user.addresses.create!(attributes_for(:address, nickname: 'home'))
      user.addresses << create(:address, street: "some street", nickname: "work")

      expect(user.default_address).to eq("#{default_address.street}, Denver, CO, 80202")
      expect(user.default_address).to_not eq("some street, Denver, CO, 80202")
    end
  end
end
