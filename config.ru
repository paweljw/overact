require 'sidekiq'
require 'sidekiq/web'
require './config/environment'

if Hanami.env == 'development'
  map '/sidekiq' do
    # Sidekiq does not provide it's own session handling
    # https://github.com/mperham/sidekiq/issues/1289#issuecomment-231051474
    use Rack::Session::Cookie, :secret => ENV['WEB_SESSIONS_SECRET']
    use Rack::Protection::AuthenticityToken

    run Sidekiq::Web
  end
end

run Hanami.app
