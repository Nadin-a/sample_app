Rails.application.routes.draw do
  root 'static_pages#home'

  # Static pages
  get '/help', to: 'static_pages#help'
  get '/about', to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'

  # Signup
  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'

  # Authentication
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  resources :users

  resources :account_activations, only: [:edit]
end
