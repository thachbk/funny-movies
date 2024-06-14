Rails.application.routes.draw do
  if ENV['ATTACHED_API_DOCS'].to_i.positive?
    mount Rswag::Api::Engine => '/api-docs'
    mount Rswag::Ui::Engine => '/api-docs'
  end

  devise_for :users,
    only: [:sessions, :registrations, :passwords, :confirmations], controllers: {
      sessions: 'users/sessions',
      registrations: 'users/registrations'
    }

  # use_doorkeeper

  resources :videos, only: %i[index new create]

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # extend ApiRoutes  unless ENV['ATTACHED_API'].to_i.zero?
  # extend SidekiqRoutes unless ENV['ATTACHED_SIDEKIQ'].to_i.zero?

  # Defines the root path route ("/")
  root "videos#index"

  # Note: declare new routes above this line
  get "/", to: "application#render200"
  post "/", to: "application#render404"
  put "/", to: "application#render404"
  delete "/", to: "application#render404"
  patch "/", to: "application#render404"
  get "*a", to: "application#render404"
  post "*a", to: "application#render404"
  put "*a", to: "application#render404"
  delete "*a", to: "application#render404"
  patch "*a", to: "application#render404"
end
