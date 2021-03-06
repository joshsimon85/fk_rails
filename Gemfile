source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

#ruby '2.5.5'

gem 'aws-sdk-s3', '~> 1.57'
gem 'devise'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'mailgun-ruby', '~> 1.2.0'
gem 'rails', '~> 6.0.0'
# Use sqlite3 as the database for Active Record
#gem 'sqlite3'
# Use Puma as the app server
gem 'puma', '~> 4.3', '>= 4.3.1'
# Use SCSS for stylesheets
gem 'sentry-raven'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
#gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false
gem 'bootstrap', '= 4.6.0'
gem 'fabrication', '~> 2.20', '>= 2.20.2'
gem 'faker', '~> 2.4'
gem 'faraday', '~> 0.17.3'
gem 'faraday_middleware', '~> 0.13.1'
gem 'font-awesome-rails'
gem 'haml', '~> 5.1', '>= 5.1.2'
gem 'jquery-rails'
gem 'image_processing', '~> 1.9', '>= 1.9.3'
gem 'omniauth', '~> 1.9'
gem 'pg', '~> 1.1', '>= 1.1.4'
gem 'recaptcha', '~> 5.2', '>= 5.2.1'
gem 'sidekiq', '~> 4.2'
gem 'webpacker', '~> 4.0', '>= 4.0.7'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'dotenv-rails', '~> 2.7', '>= 2.7.5'
  gem 'pry'
  gem 'rexml', '~> 3.2', '>= 3.2.2'
  gem 'rspec-rails', '~> 4.0.2'
  gem 'rails-controller-testing', '~> 1.0', '>= 1.0.4'
  gem 'shoulda-matchers', '~> 4.1', '>= 4.1.2'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'letter_opener', '~> 1.7'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'capybara-email', '~> 3.0', '>= 3.0.1'
  gem 'database_cleaner', '~> 1.7'
  gem 'launchy', '~> 2.4', '>= 2.4.3'
  gem 'selenium-webdriver'
  # Easy installation and use of chromedriver to run system tests with Chrome
  gem 'webdrivers'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
