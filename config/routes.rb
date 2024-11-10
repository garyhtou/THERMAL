Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  devise_scope :user do
    # Since there's no actual GET sign in page (only a POST that handles Google OAuth), redirect to the home page which
    # contains a "Sign In" button and serves as the sign in page.
    get "sign_in", to: redirect("/", status: 302), as: :new_user_session
    delete "sign_out", to: "devise/sessions#destroy", as: :destroy_user_session
  end

  root "home#index"
end
