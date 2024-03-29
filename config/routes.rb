Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  resources :users, only: %i[show edit update]
  resources :services, only: %i[index show] do
    resources :reviews, only: %i[create destroy]
    get :query, on: :collection
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
