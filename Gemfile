source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.0'

# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem 'rack-cors'

gem 'activeadmin', '~> 2.2.0'
gem 'delayed_job_active_record', '~> 4.1.3'
gem 'devise', '~> 4.7.0'
gem 'devise_token_auth', '~> 1.1.2'
gem 'draper', '~> 3.1'
gem 'figaro', '~> 1.1.1'
gem 'geokit-rails', '~> 2.3', '>= 2.3.1'
gem 'haml-rails', '~> 1.0.0'
gem 'jbuilder', '~> 2.9.1'
gem 'kaminari', '~> 1.1', '>= 1.1.1'
gem 'koala', '~> 2.4'
gem 'oj', '~> 3.7', '>= 3.7.12'
gem 'pg', '~> 0.18.2'
gem 'pry-rails', '~> 0.3.6'
gem 'puma', '~> 3.0'
gem 'rack-cors', '~> 0.4.0'
gem 'rpush', '~> 4.1', '>= 4.1.1'
gem 'sendgrid', '~> 1.2.4'
gem 'sprockets', '~> 3.7.2'
gem 'webpacker', '~> 4.0'


group :development, :test do
  gem 'bullet', '~> 6.0.2'
  gem 'factory_bot_rails', '~> 4.8.2'
  gem 'pry-byebug', '~> 3.3.0', platform: :mri
  gem 'rspec-rails', '~> 3.8.2'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'annotate', '~> 2.6.5'
  gem 'better_errors', '~> 2.1.1'
  gem 'brakeman', '~> 4.4.0'
  gem 'letter_opener', '~> 1.4.1'

  gem 'rails_best_practices', '~> 1.19.4'
  gem 'reek', '~> 5.3.1'
  gem 'rubocop-rails', '~> 2.3'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'faker', '~> 2.4.0'
  gem 'shoulda-matchers', '~> 3.1.1'
  gem 'simplecov', '~> 0.13.0', require: false
  gem 'webmock', '~> 2.3.2'
  gem 'rspec-json_expectations'
end

group :assets do
  gem 'uglifier', '~> 2.7.2'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
