Rails.application.routes.draw do
  root 'static_pages#home'
  get '/help', to: 'static_pages#help'

  get '/signup', to: 'users#new'
  
  get    '/login', to: 'sessions#new'
  post   '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  
  resources :users do
    member do
      get 'following', 'followers'
    end
  end
  
  resources :posts, except: [:index] do
    collection do
      get 'index', as: :index
    end
    
    member do
      post 'reply', to: 'replies#create', as: :reply
      patch 'reply/:reply_id', to: 'replies#update'
      delete 'reply/:reply_id', to: 'replies#destroy'
    end
  end
  get '/posts', to: 'posts#home'
  
  resources :account_activations, only: [:edit]
  resources :resend_emails,       only: [:new, :create]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :relationships,       only: [:create, :destroy]
  resources :time_posts,          only: [:create, :update, :destroy]
end