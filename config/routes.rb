Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
  root to: 'pages#index'

  get '/about', to: 'pages#about'
  get '/contact', to: 'emails#new'
  post '/contact', to: 'emails#create'
end
