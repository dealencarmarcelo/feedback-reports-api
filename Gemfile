source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.2"

gem "rails", "~> 7.2.2"
gem "pg", "~> 1.6"
gem "puma"
gem "bcrypt", "~> 3.1.7"
gem "bootsnap", ">= 1.4.4", require: false

gem "clickhouse-activerecord"

gem "active_model_serializers", "~> 0.10.0"
gem "jsonapi-serializer"

group :development, :test do
  gem "rspec-rails"
  gem "factory_bot_rails"
  gem "faker"
  gem "shoulda-matchers"
  gem "database_cleaner"
  gem "database_cleaner-active_record"
  gem "pry-rails"
  gem "rubocop-rails-omakase", require: false
  gem "brakeman", require: false
end

group :development do
  gem "listen", "~> 3.3"
end
