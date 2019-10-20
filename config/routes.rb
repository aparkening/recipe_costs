Rails.application.routes.draw do
  root 'application#index'
  
  # Ingredients
  resources :ingredients
  post 'ingredients/import'

  # Users, with recipes and user_ingredients
  resources :users do
    resources :recipes
    post 'recipes/import'
    resources :user_ingredients, as: 'ingredients'
  end
  resources :recipes, only: :index

  # Session
  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  get '/logout' => 'sessions#destroy'

  # Google authentication
  get 'auth/:provider/callback', to: 'sessions#googleAuth'
  get 'auth/failure', to: redirect('/')


  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
