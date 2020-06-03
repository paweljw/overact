require 'sidekiq'
require 'sidekiq/web'
require './config/environment'

map '/sidekiq' do
  run Sidekiq::Web
end

run Hanami.app
