source "https://rubygems.org"

# pick Ruby version for Heroku (needs Bundler >= 1.2.0.pre.1)
ruby '2.0.0'

gem "sinatra", "~> 1.4.3"
gem "sinatra-contrib", "~> 1.4.0"

gem "dnsruby", "~> 1.54"
gem "whois", "~> 3.2.1"
gem "geoip", "~> 1.2.2"
gem "domainatrix", "~> 0.0.11"
gem "simpleidn", "~> 0.0.4"

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
  gem "factory_girl", "~> 4.2.0"
  gem "rspec", "~> 2.14.1"
end