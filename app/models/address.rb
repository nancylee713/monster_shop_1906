class Address < ApplicationRecord
  validates_presence_of :street, :city, :state, :zipcode, :nickname

  belongs_to :user
end
