Rails.application.routes.draw do
  get 'resend_emails/new'

  root 'static_pages#home'
  get '/help', to: 'static_pages#help'

  get '/signup', to: 'users#new'
  
  get    '/login', to: 'sessions#new'
  post   '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  
  get  '/resend_email/new', to: 'resend_emails#new'
  post '/resend_email'    , to: 'resend_emails#create'
  
  resources :users
  
  resources :posts, except: [:index] do
    collection do
      get 'index', as: :index
    end
  end
  get '/posts', to: 'posts#home'
  
  resources :account_activations, only: [:edit]
end