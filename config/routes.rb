Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  resources :admins, only: [:index] do
    resources :emails, only: [:index, :show, :delete, :destroy] do
      collection do
        delete 'destroy_multiple'
      end
    end 
    require 'sidekiq/web'
    mount Sidekiq::Web => '/sidekiq'
  end

  resources :users, only: :show

  resources :emails, only: [:new, :create]

  root to: 'pages#index'

  get '/about', to: 'pages#about'
  get '/contact', to: 'emails#new'
  post '/contact', to: 'emails#create'
end
