Rails.application.routes.draw do

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
