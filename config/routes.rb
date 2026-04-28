Rails.application.routes.draw do
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

  # Devise導入後に有効になる想定
  # devise_for :users
end
