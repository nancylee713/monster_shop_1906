require 'rails_helper'

describe Coupon, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_uniqueness_of :name }
    it { should validate_length_of(:name).is_equal_to(10) }
    it { should validate_presence_of :value }
    it { should validate_presence_of :is_enabled }
    it { should validate_inclusion_of(:is_enabled).in_array([true, false]) }
  end

  describe "relationships" do
    it {should have_many :coupon_users}
    it {should have_many(:users).through(:coupon_users)}
    it {should belong_to :merchant}
  end

end
