
Rails.application.routes.draw do

    # Add a root route for the main domain
  root to: proc { [200, {}, ["Rails API is running! Go to /api/v1/boards"]] }
  
  # Or create a simple home controller
  # root "home#index"
  
  # Add a health check for Railway/monitoring
  get "/health", to: proc { [200, {}, ["OK"]] }
  namespace :api do
    namespace :v1 do
      post "/signup", to: "users#create"
         get "/profile", to: "users#profile" # Add this
      post "/login", to: "users#login"
        delete "/logout", to: "users#logout" # Optional: backend logout
      get "/users", to: "users#index"
       patch "/users/:id", to: "users#update"  # Add this for role updates
    delete "/users/:id", to: "users#destroy" # Add this for deleting users
      patch "/tasks/:id/move", to: "api/v1/tasks#move"
      resources :admin, only: [ :index ]
      resources :boards  do
        resources :columns, only: [:index, :show, :create, :update, :destroy] do
          resources :tasks
           member do
    patch :move
  end
        end
      end
    end
  end
end
