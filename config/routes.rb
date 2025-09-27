Rails.application.routes.draw do
  resources :projects do
    resources :knowledge_queryfiers do
      collection do
        get  :import_knowledge_queryfier, action: :import_view
        post :import_knowledge_queryfier, action: :import
        post :export, action: :export
      end
    end
    get "/kg_swagger", to: "knowledge_queryfiers#kg_swagger"
    # get "/kg_swagger_development", to: "knowledge_queryfiers#kg_swagger_development" # chat interface and side bar of kg_swagger
    member do
      get :kg_swagger_development, to: "knowledge_queryfiers#kg_swagger_development"
      post :kg_swagger_dev_agent, to: "knowledge_queryfiers#kg_swagger_dev_agent"
    end

    # get "/kg_swagger.json", to: "knowledge_queryfiers#kg_swagger", constraints: { format: :json } # JSON spec
    match "/kg_api/*splat",
    to: "knowledge_queryfiers#execute_kg",
    via: [ :get, :post, :put, :delete ]

    resources :db_scrappers
  end
  devise_for :users, controllers: {
    sessions: "users/sessions"
  }
  root to: "home#index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
