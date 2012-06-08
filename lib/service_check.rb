# Check services running on a certain server.

class ServiceCheck

  def self.check_mail(host, port=25, ehlo=host)
    mailserver = nil
    begin
      Net::SMTP.start(host, port, ehlo) do |smtp|
        mailserver = smtp
      end
    end
    mailserver
  end

  def self.check_http(host, file='/')
    uri = URI.parse("http://"+host+file)
    http = Net::HTTP.new(uri.host, uri.port)
    http.open_timeout = 5 # seconds
    http.read_timeout = 5 # seconds

    httpresult = nil

    response = http.request_get(uri.request_uri)
    unless response.nil?
      httpresult = {}
      httpresult[:code] = response.code
      httpresult[:message] = response.message

      response.header.each_header do |key, value|
        if %w{server via}.include?(key)
          httpresult[key.to_sym] = value
        end
      end
    end
    httpresult
  end

  def self.check_ssl(host, file='/')
    uri = URI.parse("https://"+host+file)
    http = Net::HTTP.new(uri.host, uri.port)
    http.ssl_timeout = 5 # seconds
    http.open_timeout = 5 # seconds
    http.read_timeout = 5 # seconds
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    cert = nil

    begin
      response = http.request_get(uri.request_uri) do |response|
        cert = http.peer_cert
      end
    rescue Errno::ECONNREFUSED
    end

    certinfo = nil

    unless cert.nil?
      # we have an OpenSSL::X509::Certificate object here
      certinfo = {}

      %w[issuer subject].each do |group|
        certinfo[group.to_sym] = {}

        cert.send(group).to_a.each do |part|
          certinfo[group.to_sym][part[0].to_sym] = part[1].to_s
        end
      end
    end
    certinfo
  end

end