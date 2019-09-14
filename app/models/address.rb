class Address < ApplicationRecord
  validates_presence_of :name, :street, :city, :state, :zipcode, :nickname

  belongs_to :user
end
