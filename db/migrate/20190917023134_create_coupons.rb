class CreateCoupons < ActiveRecord::Migration[5.1]
  def change
    create_table :coupons do |t|
      t.string :name
      t.float :value
      t.boolean :is_percent
      t.integer :item_id
      t.boolean :is_enabled, default: true
      t.boolean :is_redeemed, default: false
      t.references :merchant, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
