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
  @query = @dns = @whois = @geoip = @asnum = nil
  @nameserver = "8.8.8.8" # Google
  erb :resolve
end

get '/resolve' do
  @query = params[:query]
  @nameserver = params[:nameserver]
  
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
  
  # render
  erb :resolve
end