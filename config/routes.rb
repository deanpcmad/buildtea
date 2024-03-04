Rails.application.routes.draw do

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  post "webhooks/buildkite", to: "webhooks#buildkite", as: :buildkite_webhook
  post "webhooks/gitea/:token", to: "webhooks#gitea", as: :gitea_webhook

  root "repos#index"

  resources :repos, except: [:edit, :update] do
    member do
      put :gitea
      put :buildkite
      get :builds
    end
  end

end
