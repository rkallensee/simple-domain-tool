require 'bundler'
Bundler.require

require "sinatra/reloader" if development?
require "resolv"
require "net/http"
require "net/https"

# disable sessions b/c of Rack bug throwing "can't convert nil into String" error
#enable :sessions

configure do
  # load classes from lib dir
  $LOAD_PATH.unshift("#{File.dirname(__FILE__)}/lib")
  Dir.glob("#{File.dirname(__FILE__)}/lib/*.rb") { |lib|
    require File.basename(lib, '.*')
    also_reload File.basename(lib, '.*') if development?
  }
end

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
