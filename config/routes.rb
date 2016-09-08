Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }

  get '/items/:id(.:format)' => 'items#show', as: :item
  post   '/items(.:format)' => 'items#create'
  get    '/items/new(.:format)' => 'items#new', as: :new_item

  post   '/carts(.:format)' => 'carts#create', as: :cart
  get '/carts/(.:format)' => 'carts#show'
  delete '/carts/(.:format)' => 'carts#destroy'

  resources :orders

  get   '/searches(.:format)' => 'searches#index', as: :search


  resources :categories
  root 'categories#index'
end
