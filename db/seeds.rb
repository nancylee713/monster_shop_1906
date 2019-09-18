gem 'factory_bot_rails'
gem 'faker'
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

ItemOrder.destroy_all
Order.destroy_all
Coupon.destroy_all
Address.destroy_all
User.destroy_all
Review.destroy_all
Item.destroy_all
Merchant.destroy_all

bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
dunder = Merchant.create(name: "Dunder Mifflin Paper Co", address: '1725 Slough Ave.', city: 'Scranton', state: 'PA', zip: 18501)

#bike_shop items
tire = bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
bike = bike_shop.items.create(name: "Red Bike", description: "Oldie, but goodie", price: 200, image: "https://i.pinimg.com/originals/9d/5f/29/9d5f29749894957753a9edd9e2358d8b.png", inventory: 10)
watch = bike_shop.items.create(name: "Watch", description: "It's OK.", price: 40, image: "https://cdn.shopify.com/s/files/1/1666/5401/products/IMG-7040_1024x.JPG?v=1504456880", active?:true, inventory: 0)

#dog_shop items
pull_toy = dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
dog_bone = dog_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)

#dunder items
ream = dunder.items.create(name: "Ream of Paper", description: "So much paper!", price: 8, image: "https://mercari-images.global.ssl.fastly.net/photos/m66267444043_1.jpg?1567729247", inventory: 174)
dundie = dunder.items.create(name: "Dundie Award", description: "Everyone wants one!", price: 16, image: "https://images-na.ssl-images-amazon.com/images/I/712t-j2WvwL._UX679_.jpg", inventory: 12)

#reviews
tire_reviews = FactoryBot.create_list(:review, 5, item: tire)
bike_reviews = FactoryBot.create_list(:review, 5, item: bike)
pull_toy_reviews = FactoryBot.create_list(:review, 5, item: pull_toy)
dog_bone_reviews = FactoryBot.create_list(:review, 5, item: dog_bone)
ream_reviews = FactoryBot.create_list(:review, 5, item: ream)
dundie_reviews = FactoryBot.create_list(:review, 5, item: dundie)

#users
user_1 = FactoryBot.create(:user)
address_1 = FactoryBot.create(:address, nickname: "work 1")
address_2 = FactoryBot.create(:address, nickname: "work 2")

user_2 = FactoryBot.create(:user)
address_3 = FactoryBot.create(:address, nickname: "dorm 1")
address_4 = FactoryBot.create(:address, nickname: "dorm 2")
address_5 = FactoryBot.create(:address, nickname: "dorm 3")

merchant_employee = FactoryBot.create(:merchant_employee, merchant: bike_shop)
merchant_admin = FactoryBot.create(:merchant_admin, merchant: bike_shop)
admin = FactoryBot.create(:admin)

#coupons
coupon_1 = FactoryBot.create(:coupon, merchant: bike_shop, item_id: tire.id, user: user_1)
coupon_2 = FactoryBot.create(:coupon, merchant: dunder, item_id: dundie.id, user: user_1)

#orders
order_1 = FactoryBot.create(:order, user: user_1, address: address_1, status: 0)
  item_order_1 = ItemOrder.create!(order: order_1, item: tire, quantity: 2, price: tire.price, user: user_1, fulfilled?: 0)
  item_order_2 = ItemOrder.create!(order: order_1, item: bike, quantity: 5, price: bike.price, user: user_1, fulfilled?: 0)
  item_order_3 = ItemOrder.create!(order: order_1, item: watch, quantity: 5, price: watch.price, user: user_1, fulfilled?: 0)

order_2 = FactoryBot.create(:order, user: user_2, address: address_3, status: 0)
  item_order_4 = ItemOrder.create(order: order_2, item: bike, quantity: 12, price: bike.price, user: user_2)
  item_order_5 = ItemOrder.create(order: order_2, item: dog_bone, quantity: 3, price: dog_bone.price, user: user_2)

order_3 = FactoryBot.create(:order, user: user_1, address: address_2)
  item_order_6 = ItemOrder.create(order: order_3, item: pull_toy, quantity: 4, price: pull_toy.price, user: user_1)
  item_order_7 = ItemOrder.create(order: order_3, item: dog_bone, quantity: 3, price: dog_bone.price, user: user_1)
  item_order_8 = ItemOrder.create(order: order_3, item: tire, quantity: 1, price: tire.price, user: user_1)
  item_order_9 = ItemOrder.create(order: order_3, item: bike, quantity: 1, price: bike.price, user: user_1)

order_4 = FactoryBot.create(:order, user: user_2, address: address_4)
  item_order_10 = ItemOrder.create(order: order_4, item: pull_toy, quantity: 4, price: pull_toy.price, user: user_2)
  item_order_11 = ItemOrder.create(order: order_4, item: dog_bone, quantity: 3, price: dog_bone.price, user: user_2)

order_5 = FactoryBot.create(:order, user: user_2, address: address_5)
  item_order_12 = ItemOrder.create(order: order_5, item: pull_toy, quantity: 4, price: pull_toy.price, user: user_2)
  item_order_13 = ItemOrder.create(order: order_5, item: dog_bone, quantity: 3, price: dog_bone.price, user: user_2)
