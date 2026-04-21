require "rack/session"

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :problems,    only: [:index, :show]
      resources :submissions, only: [:create, :show]
    end
  end

  require "sidekiq/web"
  Sidekiq::Web.use(Rack::Session::Cookie, {
    secret:    SecureRandom.hex(32),
    same_site: true,
    max_age:   86400
  })
  mount Sidekiq::Web => "/sidekiq"
end