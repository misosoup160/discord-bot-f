# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.3'

# Ruby 3.2.3 compatibility
gem 'bootsnap', '>= 1.4.4', require: false
gem 'concurrent-ruby', '1.3.4'
gem 'jbuilder', '~> 2.7'
gem 'pg', '~> 1.5'
gem 'puma', '~> 7.2'
gem 'rails', '~> 6.1.7'
gem 'sass-rails', '>= 6'
gem 'turbolinks', '~> 5'
gem 'webpacker', '~> 5.0'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails'
  gem 'rspec-rails', '~> 6.1'
end

group :development do
  gem 'bullet'
  gem 'listen', '~> 3.3'
  gem 'rack-mini-profiler', '~> 4.0'
  gem 'rubocop', require: false
  gem 'rubocop-fjord', require: false
  gem 'rubocop-rails', require: false
  gem 'slim_lint'
  gem 'spring'
  gem 'web-console', '>= 4.1.0'
end

group :test do
  gem 'capybara', '>= 3.40'
  gem 'selenium-webdriver', '>= 4.0'
  gem 'webmock'
end

gem 'discordrb'
gem 'dotenv-rails'
gem 'kaminari'
gem 'omniauth'
gem 'omniauth-discord'
gem 'omniauth-rails_csrf_protection'
gem 'rails-i18n', '~> 6.0.0'
gem 'slim-rails'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
