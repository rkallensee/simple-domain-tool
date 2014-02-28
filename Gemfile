source 'https://rubygems.org'

# pick Ruby version for Heroku
ruby '2.1.0'

gem "sinatra", "~> 1.4.4"
gem "sinatra-contrib", "~> 1.4.2"

gem "dnsruby", "~> 1.54"
gem "whois", "~> 3.4.4"
gem "geoip", "~> 1.3.5"
gem "domainatrix", "~> 0.0.11"
gem "simpleidn", "~> 0.0.5"

gem "bootstrap-sass", "~> 3.1.1.0"
gem "compass", "~> 0.12.2"

group :heroku do
  gem "heroku"
end

group :production do
  gem "unicorn"
  gem "newrelic_rpm"
end

group :development do
  gem "thin"
end

group :test do
  #gem "capybara", "~> 1.1.2"
  gem "factory_girl", "~> 4.4.0"
  gem "rspec", "~> 2.14.0"
end
