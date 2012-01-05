# dns.rb
# start with "ruby -rubygems dns.rb"
# start with >> shotgun hello.rb << to reload after each request, or with >> rackup << via Bundler!

# links:
# http://www.sinatrarb.com/intro.html
# http://www.sinatrarb.com/2011/03/03/sinatra-1.2.0.html

require 'rubygems'
require 'sinatra'
require 'bundler'
require 'erb'
require 'dnsruby'

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

require_relative 'environment'
require_relative './helpers/sinatra'

get '/' do
  @query = @result = nil
  @nameserver = "8.8.8.8"
  erb :resolve
end

post '/resolve' do
  @query = params[:query]
  @nameserver = params[:nameserver]
  
  begin
    # http://dnsruby.rubyforge.org/
    res = Dnsruby::Resolver.new
	
	unless @nameserver.empty?
	  res.nameserver = @nameserver
	end
	
    @result = res.query(@query, Dnsruby::Types.ANY).to_s
  rescue
    @result = nil
	flash("Error!")
  end
  erb :resolve
end