Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }
  resources :items, only: [:new, :show, :create]

  post '/item_carts' => 'item_carts#create', as: :item_carts
  delete '/item_carts' => 'item_carts#destroy'

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
