class ItemOrder <ApplicationRecord
  validates_presence_of :item_id, :order_id, :price, :quantity
  validates :fulfilled?, inclusion: {:in => [true, false]}
  belongs_to :item
  belongs_to :order
  belongs_to :user
  has_many :merchants, through: :item

  def subtotal
    price * quantity
  end

  def instock?
    self.item.inventory >= self.quantity
  end

  def update_status
    self.update(fulfilled?: true)
  end

  def self.display_info(order)
    where("order_id=#{order.id}").group_by(&:order_id)
  end
end
