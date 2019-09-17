class Coupon < ApplicationRecord
  validates :name, presence: true, uniqueness: true, length: { is: 10 }
  validates :value, presence: true, numericality: { only_float: true }
  validates :item_id, presence: true, numericality: { greater_than_or_equal_to: 1, only_integer: true }
  validates_inclusion_of :is_percent, in: [true, false]
  validates_presence_of :is_enabled, inclusion: { in: [true, false] }
  validates_inclusion_of :is_redeemed, in: [true, false]

  belongs_to :merchant
  belongs_to :user, optional: true

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
end
