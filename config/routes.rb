Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }
  resources :items, only: [:new, :show, :create]

  resources :item_carts, only: :create

  get '/carts/(.:format)' => 'carts#show', as: :cart
  put '/carts/(.:format)' => 'carts#update'
  delete '/carts/(.:format)' => 'carts#destroy'

  resources :orders

  resources :searches, only: :index

  resources :categories

  root 'categories#index'
end
