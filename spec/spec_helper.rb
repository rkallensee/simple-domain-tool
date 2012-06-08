# Load the Sinatra app
require File.dirname(__FILE__) + '/../dns'

require 'rspec'
require 'rack/test'

set :environment, :test
#Sinatra::Application.environment = :test

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
end