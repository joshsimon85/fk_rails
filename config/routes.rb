Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  resources :admins, only: [:index] do
    require 'sidekiq/web'
    mount Sidekiq::Web => '/sidekiq'
  end

  root to: 'pages#index'

  get '/about', to: 'pages#about'
  get '/contact', to: 'emails#new'
  post '/contact', to: 'emails#create'
end
