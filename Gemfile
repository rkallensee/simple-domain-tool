source :rubygems

# pick Ruby version for Heroku (needs Bundler >= 1.2.0.pre.1)
ruby '1.9.3'

gem "sinatra", "~> 1.3.3"
gem "sinatra-contrib", "~> 1.3.2"

gem "dnsruby", "~> 1.53"
gem "whois", "~> 2.7.0"
gem "geoip", "~> 1.2.0"
gem "domainatrix", "~> 0.0.11"
gem "simpleidn", "~> 0.0.4"

group :heroku do
  gem "heroku"
end

group :production do
  gem "eventmachine", "1.0.0.beta.4.1", :platforms => :mingw_19
  gem "thin"
  gem "newrelic_rpm"
end

group :test do
  #gem "capybara", "~> 1.1.2"
  gem "factory_girl", "~> 3.3.0"
  gem "rspec", "~> 2.10.0"
end