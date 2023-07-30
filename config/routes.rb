Rails.application.routes.draw do
  root "home#index"
  get "/login", to: "home#login"
  get "/profile", to: "home#profile"
  get "/onboarding/step1", to: "home#onboarding_step1"
  get "/onboarding/step2", to: "home#onboarding_step2"
  get "/onboarding/step3", to: "home#onboarding_step3"
  get "/onboarding/step4", to: "home#onboarding_step4"
  get "/posts/post1", to: "home#post1"
  get "/dashboard", to: "home#dashboard"
end
