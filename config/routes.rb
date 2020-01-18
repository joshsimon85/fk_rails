Rails.application.routes.draw do
  devise_for :users, :path => '/user', controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
  }

  namespace :users, path: '/user' do
    get '/testimonial', to: 'testimonials#edit'
    patch '/testimonial', to: 'testimonials#update'
    delete '/testimonial', to: 'testimonials#destroy'
  end

  namespace :admin do
    root 'admins#index'

    resources :emails, only: [:index, :show, :delete, :destroy] do
      collection do
        delete 'destroy_multiple'
      end
    end

    resources :testimonials do
      collection do
        delete 'destroy_multiple'
      end

      resource :highlight, only: [:new, :create, :edit, :update, :destroy]
    end

    resources :reports, only: [:index, :delete, :destroy] do
      collection do
        delete 'destroy_multiple'
      end
    end

    require 'sidekiq/web'
    mount Sidekiq::Web => '/sidekiq'

    get '/customers', to: 'users#index'
    delete '/customers/delete/:id', to: 'users#destroy', as: 'delete_customer'
    get '/profile/edit', to: 'admins#edit'
    patch '/profile/edit', to: 'admins#update'
    post '/send_testimonial_link/:id', to: 'users#send_testimonial_link'
    get '/password/edit', to: 'passwords#edit'
    patch '/password/edit', to: 'passwords#update'
    get '/search', to: 'searches#index'
  end

  root to: 'pages#index'

  get '/about', to: 'pages#about'
  get '/privacy-policy', to: 'pages#privacy_policy'
  get '/contact', to: 'users/emails#new'
  post '/contact', to: 'users/emails#create'
  get '/testimonials', to: 'users/testimonials#index'
  get '/testimonial/:token', to: 'users/testimonials#new', as: 'new_user_testimonial'
  post '/testimonial/:token', to: 'users/testimonials#create'
  get 'expired_token', to: 'users/testimonials#expired_token', as: 'expired_token'
end
