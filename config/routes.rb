Rails.application.routes.draw do
  root to: 'pages#index'

  get '/about', to: 'pages#about'
  get '/contact', to: 'pages#contact'

  resource :emails, only: [:new, :create]
end
