Rails.application.routes.draw do
  mount Rswag::Api::Engine => "/api-docs"
  mount Rswag::Ui::Engine => "/api-docs"

  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      resources :players, only: [ :index, :show ] do
        get :stats, on: :member

        collection do
          get :leaderboard
        end
      end
      resources :events, only: [ :index ]
      get "items/top", to: "items#top"
    end
  end
end
