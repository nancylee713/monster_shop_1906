class Coupon < ApplicationRecord
  validates :name, presence: true, uniqueness: true, length: { is: 10 }
  validates :value, presence: true, numericality: { only_float: true }
  validates :item_id, presence: true, numericality: { greater_than_or_equal_to: 1, only_integer: true }
  validates_inclusion_of :is_percent, :is_enabled, :is_redeemed, in: [true, false]

  belongs_to :merchant
  belongs_to :user, optional: true
  has_one :order

  def generate_code
    characters = %w(A B C D E F G H J K L M P Q R T W X Y Z 1 2 3 4 5 6 7 8 9)
    code = ''
    10.times { code << characters.sample }
    code
  end

  def item_name(id)
    self.merchant.items.find(id).name
  end

  def toggle_status
    self.toggle!(:is_enabled)
  end

  def recalculate_order_total(cart)
    item = Item.find(self.item_id)
    item_subtotal = cart.subtotal(item)

    if self.is_percent
      coupon_percent = 1 - (self.value * 0.01)
      new_subtotal = item_subtotal * coupon_percent
    else
      coupon_value = self.value
      new_subtotal = item_subtotal - coupon_value
    end

    if new_subtotal < 0
      discounted_total = cart.total - cart.subtotal(item)
    else
      discounted_total = cart.total - cart.subtotal(item) + new_subtotal
    end

    discounted_total
  end

  def show_coupon
    if self.is_percent
      "#{item_name(self.item_id)}, #{self.value}% OFF"
    else
      "#{item_name(self.item_id)}, $#{self.value} OFF"
    end
  end
end
