Rails.application.routes.draw do
  # Add a root route for the main domain
  root to: proc { [200, {}, ["Rails API is running! Go to /api/v1/boards"]] }
  
  # Add a health check for Railway/monitoring
  get "/health", to: proc { [200, {}, ["OK"]] }
  
  namespace :api do
    namespace :v1 do
      post "/signup", to: "users#create"
      get "/profile", to: "users#profile"
      post "/login", to: "users#login"
      delete "/logout", to: "users#logout"
      get "/users", to: "users#index"
      patch "/users/:id", to: "users#update"
      delete "/users/:id", to: "users#destroy"
      
      resources :admin, only: [ :index ]
      
      resources :boards do
        resources :columns, only: [:index, :show, :create, :update, :destroy] do
          # Remove column move route if not needed, or keep it separate
          # member do
          #   patch :move
          # end
          
          resources :tasks do
            member do
              patch :move  # This is for tasks
            end
          end
        end
      end
    end
  end
end