class CreateCouponUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :coupon_users do |t|
      t.references :user, foreign_key: true
      t.references :coupon, foreign_key: true
      t.boolean :is_redeemed, default: false

      t.timestamps
    end
  end
end
