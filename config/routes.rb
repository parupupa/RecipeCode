Rails.application.routes.draw do
  get 'recipes/new'
  get 'account_deletions/show'
  get 'users/show'
  devise_for :users
  # get 'static_pages/top'
  # get 'static_pages/terms'
  # get 'static_pages/privacy'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  root "static_pages#top"
  get "terms", to: "static_pages#terms"
  get "privacy", to: "static_pages#privacy"

  resource :mypage, only: [:show], controller: "users"
  resource :account_deletion, only: [:show], controller: "account_deletions"

  resources :recipes, only: [:index, :show, :new, :create]
end
