source 'https://rubygems.org'

# pick Ruby version for Heroku
ruby '2.5.0'

gem "sinatra"
gem "sinatra-contrib"

gem "dnsruby"
gem "whois"
gem "geoip"
gem "domainatrix"
gem "simpleidn"

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
