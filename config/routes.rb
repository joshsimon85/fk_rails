Rails.application.routes.draw do
  root to: 'pages#index'

  get '/about', to: 'pages#about'
  get '/emails' => redirect('/emails/new')

  resources :emails, only: [:index, :new, :create]
end
