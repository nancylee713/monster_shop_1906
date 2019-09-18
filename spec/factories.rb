FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "user-#{n}"}
    sequence(:email) { |n| "email-#{n}@email.com" }
    password { "password" }
    merchant
  end

  factory :address do
    sequence(:street) { |n| "street-#{n}"}
    city { "Denver" }
    state { "CO" }
    zipcode { "80202" }
    nickname { "home" }
    user
  end

  factory :merchant_employee, class: User do
    name { "merchant_employee" }
    sequence(:email) { |n| "me-#{n}@email.com" }
    password { "password" }
    role { 1 }
    merchant
  end

  factory :merchant_admin, class: User do
    name { "merchant_admin" }
    sequence(:email) { |n| "ma-#{n}@email.com" }
    password { "password" }
    role { 2 }
    merchant
  end

  factory :admin, class: User do
    name { "admin" }
    sequence(:email) { |n| "admin-#{n}@email.com" }
    password { "password" }
    role { 3 }
  end

  factory :order do
    sequence(:name) { |n| "order-#{n}"}
    status { 1 }
    user
    address
    coupon
  end

  factory :merchant do
    sequence(:name) { |n| "shop-#{n}"}
    address { Faker::Address.street_address }
    city { Faker::Address.city }
    state { Faker::Address.state }
    zip { Faker::Address.zip }
  end

  factory :item do
    sequence(:name) { |n| "item-#{n}" }
    sequence(:description) { |n| "description-#{n}" }
    price { Faker::Number.decimal(l_digits: 2) }
    image { Faker::LoremFlickr.image(size: "50x60") }
    inventory { Faker::Number.between(from: 1, to: 100) }
    merchant
  end

  factory :review do
    sequence(:title) { |n| "title-#{n}" }
    sequence(:content) { |n| "content-#{n}" }
    sequence(:rating) { Faker::Number.between(from: 1, to: 5) }
    item
  end

  factory :coupon do
    name { Faker::Alphanumeric.alphanumeric(number: 10).upcase }
    value { 5 }
    is_percent { true }
    is_enabled { true }
    is_redeemed { false }
    item_id { 1 }
    merchant
    user
  end
end
