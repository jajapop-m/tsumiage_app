Rails.application.routes.draw do
  get '/signup', to: 'users#new'

  root 'static_pages#home'

  get '/help', to: 'static_pages#help'
  resources :users
end
