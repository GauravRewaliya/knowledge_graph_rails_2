Rails.application.routes.draw do
  resources :api_logs
  match "/proxy/*path", to: "proxy#forward", via: :all
  match "/proxy", to: "proxy#forward", via: :all
  get "/current_user", to: "users#current_user"
  resources :user_credits
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

    resources :db_scrappers do
      collection do
        get :har_analiser, action: :har_analiser # view
      end
    end
  end
  resources :application_docs do # -> title ( SerpApi, Desc , Docs: json )
    # # rails g scaffold ApplicationDocs title desc docs:jsonb
    # Create -> https://serpapi.com/google-images-light-api // serpapi's
    # index ( open, edit ,delete )
    # update
    # delete
    # show -> main view
    # Nested routes for related resources
    resources :application_doc_requests, except: [ :index ]
    resources :application_credentials, except: [ :index ]
    resources :application_credential_proxy_logs

    # Custom actions for ApplicationDoc
    member do
      post :import_curl
      post :test_curl
      get :swagger          # HTML swagger UI
      get :swagger_spec     # JSON swagger spec
      get :swagger_ui       # Alternative swagger UI
    end
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
