class Address < ApplicationRecord
  validates_presence_of :street, :city, :state, :zipcode, :nickname

  validates :state, length: { is: 2 }
  validates :zipcode, length: { is: 5 }, numericality: { only_integer: true }

  belongs_to :user
  has_many :orders, :dependent => :destroy

  def to_s
    self.attributes
      .slice("street", "city", "state", "zipcode")
      .values
      .join(', ')
  end

  def can_be_deleted?
    self.orders.empty? || self.orders.where(status: :shipped).empty?
  end
end
