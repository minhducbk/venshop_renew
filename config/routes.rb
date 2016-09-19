Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }
  get '/items/new(.:format)' => 'items#new', as: :new_item
  get '/items/:id(.:format)' => 'items#show', as: :item
  post '/items(.:format)' => 'items#create', as: :create_item

  post '/item_carts/create(.:format)' => 'item_carts#create', as: :item_cart_create
  get '/carts/(.:format)' => 'carts#show', as: :cart
  put '/carts/(.:format)' => 'carts#update'
  delete '/carts/(.:format)' => 'carts#destroy'

  resources :orders, except: :create
  get '/order/create(.:format)' => 'orders#create', as: :order_create

  get '/searches(.:format)' => 'searches#index', as: :search

  resources :categories
  root 'categories#index'
end
