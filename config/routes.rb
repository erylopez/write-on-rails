Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
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

  resources :dashboard, only: :index
  root "home#index"
end
