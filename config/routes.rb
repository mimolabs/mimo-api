# frozen_string_literal: true

Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, path: '', path_names: {
    sign_in: 'login',
    sign_out: 'logout'
  }
  get '/api/v1/me' => 'api/v1/users#me'

  namespace :api do
    namespace :v1 do
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
    end
  end

  get 'home/index'
  root to: 'home#index'
end
