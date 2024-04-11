Rails.application.routes.draw do

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  get 'answers/create'
  get 'questionnaires/show'
  get 'users/show'
  root to: "sessions#new"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :sessions, only: [:new, :create, :destroy]
  resources :questionnaires, only: [:show]
  resources :response_details, only: [:create, :update]
  get 'login', to: 'sessions#new', as: :login
  post 'login', to: 'sessions#create'
  get 'verify', to: 'sessions#verify'
  post 'verify', to: 'sessions#verify_code'
  get 'admin_password', to: 'sessions#new_admin_password', as: 'admin_password'
  post 'admin_password', to: 'sessions#verify_admin_password', as: 'verify_admin_password'
  get 'profile', to: 'users#show', as: 'user_profile'
  get 'success', to: 'pages#success', as: 'success'
  delete 'logout', to: 'sessions#destroy', as: :logout

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
