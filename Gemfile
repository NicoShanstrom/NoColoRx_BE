source "https://rubygems.org"

ruby "3.3.6"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails"

# Use sqlite3 as the database for Active Record
# gem "sqlite3"
# Use postgresql as database for active record
gem "pg"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

gem "bcrypt"

group :development, :test do
  gem "debug", platforms: %i[ mri windows ]
  gem 'rspec-rails'
  gem "webmock"
  gem "pry"
  gem "vcr"
  gem "shoulda-matchers"
  gem "simplecov", require: false, group: :test
  gem "faker"
  gem "factory_bot_rails"
end
gem "rack-cors"
# API calls and data serialization
gem 'faraday'
gem 'jsonapi-serializer'
gem 'htmlentities' #decode HTML entities for filtering results