Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :problems,    only: [:index, :show]
      resources :submissions, only: [:create, :show]
    end
  end

  require "sidekiq/web"
  mount Sidekiq::Web => "/sidekiq"
end