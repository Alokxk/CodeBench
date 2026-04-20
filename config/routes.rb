Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :problems, only: [:index, :show]
    end
  end
end