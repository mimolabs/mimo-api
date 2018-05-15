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
        resources :splash_pages
        resources :people
      end
    end
  end

  get 'home/index'
  root to: 'home#index'
end
