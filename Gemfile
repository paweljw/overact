# frozen_string_literal: true

source 'https://rubygems.org'

gem 'haml'
gem 'hanami', '~> 1.3'
gem 'hanami-model', '~> 1.3'
gem 'image_processing', '~> 1.8'
gem 'nokogiri'
gem 'rake'

gem 'pg'

gem 'shrine', '~> 3.0'
gem 'sidekiq', '~> 6.0', '>= 6.0.2'

group :development do
  # Code reloading
  # See: https://guides.hanamirb.org/projects/code-reloading
  gem 'hanami-webconsole'
  gem 'pry'
  gem 'rubocop'
  gem 'shotgun', platforms: :ruby
end

group :test, :development do
  gem 'dotenv', '~> 2.4'
end

group :test do
  gem 'capybara'
  gem 'rspec'
end

group :production do
  # gem 'puma'
end
