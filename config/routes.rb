Rails.application.routes.draw do
  root "pages#index"

  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  get "/logout", to: "sessions#destroy"

  resources :users, only: [:index, :show, :new, :create]

  resources :friendships, only: [:create] do
    member do
      patch :accept
      patch :reject
      delete :destroy
    end
  end

  resources :groups do
    post 'join_group', on: :member
    post 'leave_group', on: :member
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
