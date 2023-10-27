Rails.application.routes.draw do
  # Defines the root path route ("/")
  root "photos#index"

  # get "/users/:id" => "users#show", as: :user

  devise_for :users

  resources :likes
  resources :follow_requests
  resources :comments
  resources :photos
  
  get "/:username" => "users#show", as: :user
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
end
