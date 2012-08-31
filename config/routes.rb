Fitbit::Application.routes.draw do
  get "logout" => "sessions#destroy", :as => "logout"
  get "login" => "sessions#new", :as => "login"
  get "signup" => "users#new", :as => "signup"
  get "start_fitbit_auth" => "users#start_fitbit_auth", :as => "start_fitbit_auth"
  get "verify_fitbit" => "users#verify_fitbit", :as => "verify_fitbit"
  root :to => "users#new"
  resources :users
  resources :sessions
  get "secret" => "secret#index"
end