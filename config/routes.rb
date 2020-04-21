Rails.application.routes.draw do
  get 'password_resets/new'

  get 'password_resets/edit'

  root 'static_pages#home'
  get '/help', to: 'static_pages#help'

  get '/signup', to: 'users#new'
  
  get    '/login', to: 'sessions#new'
  post   '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  
  resources :users
  
  resources :posts, except: [:index] do
    collection do
      get 'index', as: :index
    end
  end
  get '/posts', to: 'posts#home'
  
  resources :account_activations, only: [:edit]
  resources :resend_emails,       only: [:new, :create]
  resources :password_resets,     only: [:new, :create, :edit, :update]
end