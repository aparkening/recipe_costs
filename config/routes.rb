Rails.application.routes.draw do
  root 'application#index'
  
  resources :users

  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  get '/logout' => 'sessions#destroy'


  get 'ingredients/index'
  post 'ingredients/import'



  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
