require 'rubygems'
require 'sinatra'
require 'bundler'
require 'erb'
require 'dnsruby'
require 'whois'
require 'resolv'

# monkey-patch dnsruby which is broken on Heroku:
module Dnsruby
	class SelectThread
		def get_socket_pair
			srv = nil
			srv = TCPServer.new('::1', 0)
			rsock = TCPSocket.new(srv.addr[3], srv.addr[1])
			lsock = srv.accept
			srv.close
			return [lsock, rsock]
		end
	end
end

# disable sessions b/c of Rack bug throwing "can't convert nil into String" error
#enable :sessions

configure do
  SiteConfig = OpenStruct.new(
    :title => 'DNS util!',
    :author => 'Raphael Kallensee',
    :url_base => 'http://localhost:4567/'
  )

  # load models
  #$LOAD_PATH.unshift("#{File.dirname(__FILE__)}/lib")
  #Dir.glob("#{File.dirname(__FILE__)}/lib/*.rb") { |lib| require_relative File.basename(lib, '.*') }
end