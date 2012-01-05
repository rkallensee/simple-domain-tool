require 'rubygems'
require 'bundler'
require 'sinatra'
require 'dnsruby'
require 'erb'

require 'sinatra' unless defined?(Sinatra)

enable :sessions

configure do
  SiteConfig = OpenStruct.new(
                 :title => 'DNS util!',
                 :author => 'Raphael Kallensee',
                 :url_base => 'http://localhost:4567/'
               )

  # load models
  $LOAD_PATH.unshift("#{File.dirname(__FILE__)}/lib")
  Dir.glob("#{File.dirname(__FILE__)}/lib/*.rb") { |lib| require_relative File.basename(lib, '.*') }
end