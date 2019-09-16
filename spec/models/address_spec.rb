require 'rails_helper'

describe Address, type: :model do
  describe "validations" do
    it { should validate_presence_of :street }
    it { should validate_presence_of :city }
    it { should validate_presence_of :state }
    it { should validate_length_of(:state).is_equal_to(2) }
    it { should validate_presence_of :zipcode }
    it { should validate_numericality_of(:zipcode).only_integer }
    it { should validate_length_of(:zipcode).is_equal_to(5) }
    it { should validate_presence_of :nickname }
  end

  describe "relationships" do
    it { should belong_to :user }
    it { should have_many :orders}
  end

  describe "methods" do
    it 'to_s' do
      address = create(:address, street: 'street-1')
      expect(address.to_s).to eq("street-1, Denver, CO, 80202")
    end

    it 'can_be_deleted?' do
      user = User.create!(name: 'user-1', email: 'email-1@email.com', password: 'password')
      home_address = user.addresses.create!(id: 1, street: 'street-1', city: 'Denver', state: 'CO', zipcode: '80202', nickname: 'home')
      dorm_address = user.addresses.create!(id: 2, street: 'street-2', city: 'Denver', state: 'CO', zipcode: '80202', nickname: 'dorm')
      order_1 = create(:order, user: user, address: dorm_address)
      order_2 = create(:order, user: user, address: home_address, status: 1)
      order_3 = create(:order, user: user, address: home_address, status: 2)

      expect(dorm_address.can_be_deleted?).to eq(true)
      expect(home_address.can_be_deleted?).to eq(false)
    end
  end
end
