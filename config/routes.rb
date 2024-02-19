Rails.application.routes.draw do
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resource :sessions, only: [:new, :create, :destroy]
  get 'login', to: 'sessions#new', as: :login
  post 'login', to: 'sessions#create'
  get 'verify', to: 'sessions#verify'
  post 'verify', to: 'sessions#verify_code'
  # delete 'logout', to: 'sessions#destroy', as: :logout

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
