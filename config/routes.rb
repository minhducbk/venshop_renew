Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }
  post   '/items(.:format)' => 'items#create', as: :item
  get    '/items/new(.:format)' => 'items#new', as: :new_item

  post   '/carts(.:format)' => 'carts#create', as: :cart
  get '/carts/(.:format)' => 'carts#show'
  delete '/carts/(.:format)' => 'carts#destroy'

  resources :orders

  post   '/searches(.:format)' => 'searches#create', as: :search


  resources :categories do
    get '/items/:id(.:format)' => 'items#show', as: :item
  end
  root 'categories#index'
end
