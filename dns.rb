# dns.rb
# start with >> ruby -rubygems dns.rb <<
# start with bundler via >> bundle exec rackup <<
# start as Rack app with >> rackup << (uses config.ru)
# or with >> foreman start << (uses Procfile).

require_relative 'environment'
require_relative './helpers/sinatra'
require 'resolv'

set :public_folder, File.dirname(__FILE__) + '/static'

get '/' do
  @query = @dns = @whois = @geoip = @asnum = nil
  @nameserver = "8.8.8.8" # Google
  @path_info = request.path_info
  erb :resolve
end

get '/resolve' do
  @query = params[:query]
  @nameserver = params[:ns]
  @path_info = request.path_info
  
  res = Dnsruby::Resolver.new

  begin
	unless @nameserver.empty?
		res.nameserver = @nameserver
	end
  rescue
    flash("Error while setting nameserver!")
  end
  
  begin
    # is this an ip-address or a hostname?
	if /^(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})?$/.match(@query)
	  @ip = @query
	else
	  @ip = res.query(@query, Dnsruby::Types.A).answer.first.address.to_s
	end
  rescue
    @ip = nil
	flash("Error while getting IP / A record!")
  end
  
  begin
    # is this an ip-address or a hostname?
	if /^(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})?$/.match(@query)
	  # query DNS, but do a reverse lookup first
      @dns = res.query(Resolv.getname(@query), Dnsruby::Types.ANY).to_s
	else
	  @dns = res.query(@query, Dnsruby::Types.ANY).to_s
	end
  rescue Dnsruby::NXDomain
    @dns = nil
	flash("Error while requesting DNS information: this domain does not exist!")
  rescue
    @dns = nil
	flash("Error while requesting DNS information!")
  end
  
  begin
	@rdns = Resolv.getname(@ip)
  rescue Resolv::ResolvError
    @rdns = nil
	flash("Error while requesting Reverse DNS information!")
  end
  
  begin
	# query WHOIS
	@whois = Whois.query(@query).to_s
  rescue
    @whois = nil
	flash("Error while requesting WHOIS information!")
  end
	
  begin
	# query GeoIP
	@geoip = GeoIP.new('res/GeoLiteCity.dat').city(@query)
  rescue SocketError
    @geoip = nil
	flash("Error while requesting GeoIP city information: the host seems to be unknown!")
  rescue
    @geoip = nil
	flash("Error while requesting GeoIP city information!")
  end
	
  begin
	# query GeoIP ASNum
	@asnum = GeoIP.new('res/GeoIPASNum.dat').asn(@query)
  rescue SocketError
    @geoip = nil
	flash("Error while requesting ASNum information: the host seems to be unknown!")
  rescue
    @asnum = nil
    flash("Error while requesting ASNum information!")
  end
  
  begin
	# query DNSBLs
	@dnsbl = Dnsbl.check(@ip)
  rescue
    @dnsbl = nil
    flash("Error while requesting DNSBL information!")
  end
  
  # render
  erb :resolve
end

get '/help' do
  # static content
  @path_info = request.path_info
  erb :help
end

get '/about' do
  # static content
  @path_info = request.path_info
  erb :about
end
