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

	def self.check_web(host, file='/')
	  httpresult = {}
	  begin
		Net::HTTP.start(host) do |http|
		  response = http.get(file)
		  unless response.nil?
			httpresult[:code] = response.code
			httpresult[:message] = response.message
			
			response.header.each_header { |key,value| 
			  if %w{server via}.include?(key)
			    httpresult[key.to_s] = value
			  end
			}
		  end
		end
	  end   
      httpresult	  
  end

  def self.check_https(host, file='/')
    uri = URI.parse("https://"+host+file)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    certinfo = cert = nil

    begin
      http.start do
        http.get(uri.request_uri)
        cert = http.peer_cert
      end
    rescue Errno::ECONNREFUSED
    end

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
