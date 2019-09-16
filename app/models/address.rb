class Address < ApplicationRecord
  validates_presence_of :street, :city, :state, :zipcode, :nickname

  validates :state, length: { is: 2 }
  validates :zipcode, length: { is: 5 }, numericality: { only_integer: true }

  belongs_to :user
end
