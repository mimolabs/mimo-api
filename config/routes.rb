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
        resources :emails, only: [:index, :show]
        resources :people do 
          resources :person_timelines
        end
        resources :socials, only: [:index, :show]
        resources :senders, only: [:index, :show, :create]
        resources :splash_pages
        resources :sms, only: [:index, :show]
        resources :stations, only: [:index, :show]
      end
    end
  end

  get 'home/index'
  root to: 'home#index'
end
