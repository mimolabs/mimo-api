# frozen_string_literal: true

Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, path: '', path_names: {
    sign_in: 'login',
    sign_out: 'logout'
  }, controllers: {sessions: "sessions", passwords: 'passwords', unlocks: 'unlocks'}

  get '/api/v1/ping', controller: 'api/v1/ping', action: 'ping'
  get '/api/v1/me' => 'api/v1/users#me'
  get '/wizard/start' => 'wizard#start'
  get '/wizard/complete' => 'wizard#complete'
  post '/wizard/code' => 'wizard#send_code'
  patch '/wizard/update' => 'wizard#update'

  get 'api/v1/locations/:location_id/splash_integrations' => 'api/v1/splash_integrations#show'
  get 'api/v1/locations/:location_id/splash_integrations/:id' => 'api/v1/splash_integrations#fetch_settings',
    constraints: SplashIntegrationSites

  ### For the double opt in email confirmation
  patch 'api/v1/emails/:id' => 'api/v1/emails#confirm', constraints: EmailConfirm

  get 'api/v1/data_requests/timeline' => 'api/v1/data_requests#timeline'

  get 'api/v1/logins' => 'api/v1/login_pages#show_welcome', constraints: LoginsWelcome
  get 'api/v1/logins' => 'api/v1/login_pages#create', constraints: ApiLoginsCreate

  post 'api/v1/logins' => 'api/v1/login_pages#create'

  get 'api/v1/logins' => 'api/v1/login_pages#show'

  namespace :api do
    namespace :v1 do
      resources :data_requests do
        patch :update, on: :collection
        get :show, on: :collection
      end
      resources :locations do
        resources :audiences
        resources :boxes, only: [:destroy, :index]
        resources :sessions
        resources :people do
          resources :emails, only: [:index, :show]
          resources :person_timelines
          resources :socials, only: [:index, :show]
          resources :sms, only: [:index, :show]
          resources :stations, only: [:index, :show]
        end
        resources :senders, only: [:index, :show, :create]
        resources :splash_pages
        resources :splash_integrations
      end
      resources :users, except: [:show]
    end
  end

  get 'home/index'
  root to: 'home#index'
end
