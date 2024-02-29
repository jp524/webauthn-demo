Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "sessions/users#new"

  resources :users, only: [ :new, :create ]
  namespace :sessions do
    resource :user, only: [ :new, :create, :destroy ]
  end

  resources :static_pages, only: [ :index ]

  namespace :webauthn do
    resources :credentials, only: %i[index create destroy] do
      post :options, on: :collection, as: "options_for"
    end
    resource :authentication, controller: "authentication", only: %i[new create] do
      post :options, on: :collection, as: "options_for"
    end
  end
end
