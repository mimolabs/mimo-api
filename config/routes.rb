Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, path: '', path_names: {
    sign_in: 'login',
    sign_out: 'logout'
  }
  get "/api/v1/me" => "api/v1/users#me"
  get 'home/index'
  root :to => 'home#index'
end
