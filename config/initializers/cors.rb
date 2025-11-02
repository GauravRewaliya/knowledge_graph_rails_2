Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins "http://localhost:5173"  # Vue dev server origin
    resource "*",
             headers: :any,
             expose: [ "access-token", "client", "uid" ], # 👈 important for devise_token_auth
             methods: [ :get, :post, :put, :patch, :delete, :options, :head ],
             credentials: false
  end
end
