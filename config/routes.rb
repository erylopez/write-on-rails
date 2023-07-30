Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  get "users/auth/notion/callback", to: "users/oauth_callbacks#notion"
  root "home#index"
end
