Rails.application.routes.draw do
  get 'answers/create'
  get 'questionnaires/show'
  get 'users/show'
  root to: "sessions#new"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :sessions, only: [:new, :create, :destroy]
  resources :questionnaires, only: [:show]
  resources :answers, only: [:create]
  get 'login', to: 'sessions#new', as: :login
  post 'login', to: 'sessions#create'
  get 'verify', to: 'sessions#verify'
  post 'verify', to: 'sessions#verify_code'
  get 'profile', to: 'users#show', as: 'user_profile'


  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
