require "rack/session"

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :problems,    only: [:index, :show]
      resources :submissions, only: [:create, :show]

      resources :problems, only: [] do
        resource :followup, only: [:create], controller: "followups" do
          collection do
            post :evaluate
          end
        end
      end
    end
  end

 require "sidekiq/web"
  Sidekiq::Web.use(Rack::Auth::Basic) do |u, p|
    ActiveSupport::SecurityUtils.secure_compare(p, ENV.fetch("SIDEKIQ_WEB_PASSWORD"))
  end
  Sidekiq::Web.use(Rack::Session::Cookie, {
    secret:    ENV.fetch("SIDEKIQ_WEB_SECRET"),
    same_site: true,
    max_age:   86400
  })
  mount Sidekiq::Web => "/sidekiq"
end