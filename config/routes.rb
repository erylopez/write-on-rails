Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  get "users/auth/notion/callback", to: "users/oauth_callbacks#notion"

  resources :onboarding, only: :index do
    collection do
      get :notion_fetch_page
    end
  end
  root "home#index"
end
