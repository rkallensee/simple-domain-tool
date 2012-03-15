# Check services running on a certain server.
# Much of the code is from http://theadmin.org/articles/check-your-services-with-ruby/

class ServiceCheck
	
	def self.check_ping(host)
	  begin
	    Net::PingExternal.new(host).ping
	  end
	end

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

	def self.check_ftp(host, login, password)
	  begin
		Net::FTP.open(host) do |ftp|
		  return "FTP Server down or not responding #{ftp.last_response_code}" unless ftp.last_response_code.match(/220/)
		  if password.empty?
			ftp.login(login)
		  else
			ftp.login(login, password)
		  end
		end
	  end
	end
	
end
