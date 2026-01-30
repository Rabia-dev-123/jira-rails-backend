
Rails.application.routes.draw do
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
