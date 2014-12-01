OmniAuth.config.logger = Rails.logger

g_client_id = ENV['GOOGLE_CLIENT_ID']
g_secret = ENV['GOOGLE_SECRET']

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, g_client_id, g_secret, {client_options: {ssl: {ca_file: Rails.root.join("cacert.pem").to_s}}}
end
