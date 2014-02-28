# encoding: utf-8

# dns.rb
# start with >> ruby -rubygems dns.rb <<
# start with bundler via >> bundle exec rackup <<
# start as Rack app with >> rackup << (uses config.ru)
# or with >> foreman start << (uses Procfile).

require_relative 'environment'
require_relative './helpers/sinatra'

set :public_folder, File.dirname(__FILE__) + '/static'

get '/' do
  @query = @dns = @whois = @geoip = @asnum = @dnsbl = @services = nil
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
    flash("Error while setting custom nameserver!")
  end

  # Is this an IPv4 IP-address or a hostname?
  if @query =~ /^(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})?$/
    @ip = @query
    begin
      @hostname = Resolv.getname(@ip)
    rescue
      @hostname = nil
      flash("Given IPv4 address has no RDNS entry.")
    end
    @query_was = :ip_address
  else
    @hostname = @query

    if !@hostname.nil? and !@hostname.ascii_only?
      # we seem to have a non-ASCII hostname (IDN domain), so convert to punycode ACE string
      @hostname = SimpleIDN.to_ascii(@hostname)
    end

    begin
      @ip = res.query(@hostname, Dnsruby::Types.A).answer.first.address.to_s
    rescue
      @ip = nil
      flash("Cannot resolve A record for given hostname.")
    end
    @query_was = :hostname
  end

  begin
    @dns = res.query(@hostname, Dnsruby::Types.ANY).to_s
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
    # query WHOIS for either hostname or IP
    if @query_was == :hostname
      # make sure we have the pure domain for the WHOIS query, no subdomain
      dom_parsed = Domainatrix.parse("http://"+@hostname) # bug: Domainatrix doesn't work without scheme
      @whois = Whois.query(dom_parsed.domain_with_public_suffix).to_s.force_encoding("UTF-8")
    elsif @query_was == :ip_address
      @whois = Whois.query(@ip).to_s.force_encoding("UTF-8")
    end
  rescue
    @whois = nil
    flash("Error while requesting WHOIS information!")
  end

  begin
    # query GeoIP for either hostname or IP
    @geoip = GeoIP.new('res/GeoLiteCity.dat').city(@ip)
  rescue SocketError
    @geoip = nil
    flash("Error while requesting GeoIP city information: the host seems to be unknown!")
  rescue
    @geoip = nil
    flash("Error while requesting GeoIP city information!")
  end

  begin
    # query GeoIP ASNum for either hostname or IP
    @asnum = GeoIP.new('res/GeoIPASNum.dat').asn(@ip)
  rescue SocketError
    @geoip = nil
    flash("Error while requesting ASNum information: the host seems to be unknown!")
  rescue
    @asnum = nil
    flash("Error while requesting ASNum information!")
  end

  begin
    # query DNSBLs for IP address
    @dnsbl = Dnsbl.check(@ip)
  rescue
    @dnsbl = nil
    flash("Error while requesting DNSBL information!")
  end

  begin
    @services = {}
    # check running services
    if @query_was == :hostname
      @services[:http] = ServiceCheck.check_http(@hostname)
    elsif @query_was == :ip_address
      @services[:http] = ServiceCheck.check_http(@ip)
    end
  rescue
    @services = nil
    flash("Error while checking for running services!")
  end

  begin
    # check ssl
    if @query_was == :hostname
      @ssl = ServiceCheck.check_ssl(@hostname)
    elsif @query_was == :ip_address
      @ssl = ServiceCheck.check_ssl(@ip)
    end
  rescue
    @ssl = nil
    #flash("Error while checking for SSL certificate!")
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
