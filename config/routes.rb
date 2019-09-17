Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: "welcome#index"

  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  namespace :merchant do
    get "/", to: "dashboard#index", as: :user
    resources :orders, only: [:show]
    get "/orders/:id", to: "dashboard#show", as: :orders_show
    resources :items, as: :user

    resources :coupons
  end

  patch "/merchant/coupons/:id/update_status", to: "merchant/coupons#update_status"
  
  patch "/merchant/items/:item_id/update_status", to: "merchant/items#update_status"

  resources :merchants do
    resources :items, only: [:index]
  end

  resources :items, except: [:new, :create] do
    resources :reviews, except: [:show, :index]
  end

  # resources :orders, only: [:new, :create]
  patch "/orders/:id", to: "orders#cancel", as: :order_cancel

  namespace :admin do
    get "/", to: "dashboard#index"
    patch "/orders/:order_id/update_status", to: "dashboard#update_status"

    resources :users, only: [:index, :show]
    resources :merchants, only: [:show]
  end

  patch "/merchant/:order_id/:item_order_id/fulfill", to: "merchant/orders#fulfill"
  patch "/merchants/:id/update_status", to: "merchants#update_status"

  get "/register", to: "users#new"
  post "/register", to: "users#create"

  get "/profile", to: "users#show"
  get "/profile/edit", to: "users#edit"
  patch "/profile", to: "users#update"
  get "/profile/edit_password", to: "users#edit_password"
  patch "/profile/update_password", to: "users#update_password"

  get "/profile/orders", to: "users#show_orders"
  post "/profile/orders", to: "orders#create"
  get "/profile/orders/new", to: "orders#new"
  get "/profile/orders/:id", to: "users#show_order"

  get "profile/orders/:id/edit", to: "orders#edit", as: :order_edit
  patch "profile/orders/:id", to: "orders#update"

  get "/profile/addresses/new", to: "addresses#new"
  post "/profile/addresses", to: "addresses#create"
  get "/profile/addresses/:id/edit", to: "addresses#edit"
  patch "/profile/addresses/:id", to: "addresses#update"
  delete "/profile/addresses/:id", to: "addresses#destroy"

  post "/cart/:item_id", to: "cart#add_item"
  get "/cart", to: "cart#show"
  delete "/cart", to: "cart#empty"
  delete "/cart/:item_id", to: "cart#remove_item"
  patch "/cart/:item_id/:increment_decrement", to: "cart#increment_decrement"
end
