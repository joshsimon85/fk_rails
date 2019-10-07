Rails.application.routes.draw do
  devise_for :users

  root to: 'pages#index'

  get '/about', to: 'pages#about'
  get '/contact', to: 'emails#new'
  post '/contact', to: 'emails#create'
end
