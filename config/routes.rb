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

    resources :testimonials, only: [:index, :edit, :delete, :destroy, :update] do
      collection do
        delete 'destroy_multiple'
      end

      resource :highlight, only: [:new, :create, :edit, :update]
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
  get '/testimonial/:token', to: 'testimonials#new', as: 'new_user_testimonial'
  post '/testimonial/:token', to: 'testimonials#create'
  get 'expired_token', to: 'testimonials#expired_token', as: 'expired_token'
end
