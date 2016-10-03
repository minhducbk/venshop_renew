Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    omniauth_callbacks: "users/omniauth_callbacks"
  }

  resources :items, only: [:new, :show, :create]

  post '/cart_items' => 'cart_items#create', as: :cart_items
  delete '/cart_items' => 'cart_items#destroy'

  get '/carts/proceed_checkout' => 'carts#proceed_checkout', as: :proceed_checkout
  get '/carts/' => 'carts#show', as: :cart
  put '/carts/' => 'carts#update'
  delete '/carts/' => 'carts#destroy'

  get '/order/create' => 'orders#create', as: :order_create
  resources :orders, except: :create

  resources :searches, only: :index

  resources :categories

  root 'categories#index'
end
