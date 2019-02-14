source 'https://rubygems.org'

# pick Ruby version for Heroku
ruby '2.5.0'

gem 'sinatra'
gem 'sinatra-contrib'

gem 'dnsruby'
gem 'whois'
gem 'geoip'
gem 'domainatrix'
gem 'simpleidn'

gem 'bootstrap-sass', '~> 3.4.1'
gem 'compass', '~> 0.12.2'

group :heroku do
  gem 'heroku'
end

group :production do
  gem 'puma'
  gem 'newrelic_rpm'
  gem 'scout_apm'
end

group :development do
  gem 'thin'
end

group :test do
  #gem 'capybara', '~> 1.1.2'
  gem 'factory_girl'
  gem 'rspec'
end
