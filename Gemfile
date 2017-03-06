source 'https://rubygems.org'

ruby '2.3.1'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.0', '>= 5.0.0.1'
# Use postgresql as the database for Active Record
gem 'pg', '~> 0.18'
# Use Puma as the app server
gem 'puma', '~> 3.0'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2', '>= 4.2.0'
gem 'jquery-rails', '~>4.2', '>=4.2.1'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'

gem 'database_cleaner', '~>1.5', '>=1.5.3'
gem 'factory_girl_rails', '~>4.7', '>=4.7.0'
gem 'faker', '~>1.6', '>=1.6.6'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  gem 'rspec-rails', '~> 3.5', '>=3.5.2'
  gem 'capybara', '~> 2.10', '>=2.10.1'
  gem 'poltergeist', '~> 1.11', '>=1.11.0'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console'
  gem 'listen', '~> 3.0.5'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# Front end dependencies
source 'https://rails-assets.org' do
  gem 'rails-assets-bootstrap'
  gem 'rails-assets-angular'
  gem 'rails-assets-angular-ui-router'
  gem 'rails-assets-chartjs'
  gem 'rails-assets-angular-chartjs'
end
