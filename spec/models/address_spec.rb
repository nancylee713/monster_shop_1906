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
end
