Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  devise_for :users,
    path: "api/v1/auth",
    controllers: { sessions: "api/v1/auth/sessions" },
    only: [ :sessions ]

  namespace :api do
    namespace :v1 do
      post "auth/switch", to: "auth/switch#create"
      resource :dashboard, only: [ :show ], controller: "dashboard"
      resources :sales_trends, only: [ :index ]
      resources :return_rate_trends, only: [ :index ]
      resources :contracts, only: [ :index ]
      resources :working_hours, only: [ :index ]
      resources :users, only: [ :index ]
    end
  end
end
