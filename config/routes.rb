Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  namespace :admin do
    root 'admins#index'
    resources :emails, only: [:index, :show, :delete, :destroy] do
      collection do
        delete 'destroy_multiple'
      end
    end

    resources :testimonials, only: [:index, :edit, :update, :delete, :destroy] do
      collection do
        delete 'destroy_multiple'
      end

      resource :highlight, only: [:new, :create, :edit, :update]
    end

    require 'sidekiq/web'
    mount Sidekiq::Web => '/sidekiq'
  end

  root to: 'pages#index'

  get '/about', to: 'pages#about'
  get '/contact', to: 'users/emails#new'
  post '/contact', to: 'users/emails#create'
  get '/testimonial/:token', to: 'users/testimonials#new', as: 'new_user_testimonial'
  post '/testimonial/:token', to: 'users/testimonials#create'
  get 'expired_token', to: 'users/testimonials#expired_token', as: 'expired_token'
end
