Rails.application.routes.draw do
  devise_for :users, controllers: {omniauth_callbacks: "users/omniauth_callbacks"}
  get "users/auth/notion/callback", to: "users/oauth_callbacks#notion"

  resources :onboarding, only: :index do
    collection do
      get :notion_fetch_page
      get :step_1
      get :complete_step_1
      get :step_2
      get :complete_step_2
      get :step_3
      get :complete_step_3
      get :previous_step
      get :reset
    end
  end

  namespace :notion do
    resources :sync_pages, only: [:index, :create]
  end

  resources :posts do
    post :update_published, on: :member
  end
  resources :reposts
  resources :dashboard, only: :index

  resources :sync_posts, only: :create

  root "home#index"
  get "/login", to: "home#login"
  get "/profile", to: "home#profile"
  get "/onboarding/step1", to: "home#onboarding_step1"
  get "/onboarding/step2", to: "home#onboarding_step2"
  get "/onboarding/step3", to: "home#onboarding_step3"
  get "/onboarding/step4", to: "home#onboarding_step4"
  get "/posts/post1", to: "home#post1"
end
