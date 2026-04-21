Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  resources :moon, controller: :moons, only: [ :index ]
  root "moons#index"

  # Rotas para criação e visualização de usuários
  resources :users, only: [ :new, :create, :show ]

  # Google Calendar authentication routes
  post "google-calendar/authorize" => "google_calendar_auth#authorize"
  get "google-calendar/callback" => "google_calendar_auth#callback"
  delete "google-calendar/disconnect" => "google_calendar_auth#disconnect"

  # Defines the root path route ("/")
  # root "posts#index"
end
