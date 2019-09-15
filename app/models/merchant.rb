class Merchant < ApplicationRecord
  has_many :items, :dependent => :destroy
  accepts_nested_attributes_for :items
  has_many :item_orders, through: :items
  has_many :orders, through: :item_orders
  has_many :users, :dependent => :destroy

  validates_presence_of :name,
                        :address,
                        :city,
                        :state,
                        :zip
  validates_inclusion_of :enabled?, :in => [true, false]

  def no_orders?
    item_orders.empty?
  end

  def item_count
    items.count
  end

  def average_item_price
    items.average(:price)
  end

  def distinct_cities
    item_orders.distinct.joins(:order).pluck(:city)
  end

  def pending_orders
    orders.where(status: "pending").distinct
  end

  def activate_items
    items.each { |item| item.update(active?: true) }
  end

  def deactivate_items
    items.each { |item| item.update(active?: false) }
  end
end
