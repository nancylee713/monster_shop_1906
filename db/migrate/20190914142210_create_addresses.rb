class CreateAddresses < ActiveRecord::Migration[5.1]
  def change
    create_table :addresses do |t|
      t.string :street
      t.string :city
      t.string :state
      t.string :zipcode
      t.string :nickname

      t.timestamps
    end
  end
end
