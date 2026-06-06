# config/initializers/cors.rb
Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    # origins 'http://localhost:3000', 'http://localhost:3001', 'http://localhost:5001', 'http://localhost:5000' # Allow your React ports

    # FIXED: Dynamically matches ANY local development port loop (3000-5999)
    origins %r{\Ahttps?://localhost:\d{4}\z}

    resource '*',
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head],
      credentials: true
  end
end
