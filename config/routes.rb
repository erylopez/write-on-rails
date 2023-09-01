Rails.application.routes.draw do
  devise_for :users, controllers: {omniauth_callbacks: "users/omniauth_callbacks"}
  get "users/auth/notion/callback", to: "users/oauth_callbacks#notion"

  resources :profile, only: :index

  namespace :notion do
    resources :sync_pages, only: [:index, :create]
  end

  resources :posts do
    post :update_published_status_from_devto, on: :member
    post :delete_from_hashnode, on: :member
  end

  resources :reposts
  resources :dashboard, only: :index
  resources :sync_posts, only: :create
  resources :integrations, only: [:create]

  root "home#index"
end
