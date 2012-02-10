# dns.rb
# start with "ruby -rubygems dns.rb"
# start as Rack app with >> rackup << (uses config.ru)
# or with >> foreman start << (uses Procfile).

# links:
# http://www.sinatrarb.com/intro.html

require_relative 'environment'
require_relative './helpers/sinatra'

set :public_folder, File.dirname(__FILE__) + '/static'

get '/' do
  @query = @dns = @whois = nil
  @nameserver = "8.8.8.8" # Google
  erb :resolve
end

get '/resolve' do
  @query = params[:query]
  @nameserver = params[:nameserver]
  
  begin
    # http://dnsruby.rubyforge.org/
    res = Dnsruby::Resolver.new
	
	unless @nameserver.empty?
	  res.nameserver = @nameserver
	end
  
    # is this an ip-address or a hostname?
	if /^(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})?$/.match(@query)
	  # query DNS, but do a reverse lookup first
      @dns = res.query(Resolv.getname(@query), Dnsruby::Types.ANY).to_s
	else
	  @dns = res.query(@query, Dnsruby::Types.ANY).to_s
	end
	
	# query WHOIS
	@whois = Whois.query(@query).to_s
  rescue
    @dns = @whois = nil
    flash("Error while requesting DNS/WHOIS information!")
  end
  
  # render
  erb :resolve
end