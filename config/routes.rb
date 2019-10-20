Rails.application.routes.draw do
  root 'application#index'
  
  resources :users do
    resources :recipes
    post 'recipes/import'
    resources :ingredients, only: [:index, :new, :create, :edit, :update, :destroy] 
  end
  resources :recipes, only: :index
  post 'ingredients/import'


  # Session
  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  get '/logout' => 'sessions#destroy'



  # Google authentication
  get 'auth/:provider/callback', to: 'sessions#googleAuth'
  get 'auth/failure', to: redirect('/')


  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
