# Check if hostname is listed in DNSBLs.
# Inspired by http://snipplr.com/view/13480/ruby-script-to-check-if-ip-address-is-listed-in-a-dnsbl-rbls/

class Dnsbl
  def self.check(ip)
	lists = %w[
	    b.barracudacentral.org
		bl.spamcop.net
		blackholes.mail-abuse.org
		block.dnsbl.sorbs.net
		dialups.mail-abuse.org
		dnsbl.sorbs.net   
		dul.dnsbl.sorbs.net   
		http.dnsbl.sorbs.net
		list.dsbl.org
		misc.dnsbl.sorbs.net
		relays.bl.kundenserver.de
		relays.mail-abuse.org
		sbl.spamhaus.org
		sbl-xbl.spamhaus.org
		smtp.dnsbl.sorbs.net
		socks.dnsbl.sorbs.net
		spam.dnsbl.sorbs.net
		spam.dnsrbl.net
		unconfirmed.dsbl.org
		whois.rfc-ignorant.org
		will-spam-for-food.eu.org
		xbl.spamhaus.org
		zombie.dnsbl.sorbs.net
	]
	
	lists_min = %w[
	    b.barracudacentral.org
		dnsbl.sorbs.net
		relays.mail-abuse.org
		zen.spamhaus.org
		whois.rfc-ignorant.org
	]

	raise ArgumentError, "Invalid IP specified" if ip.is_a? String and !ip.match(/\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}/)

	check = ip.split('.').reverse.join('.')

	listed = []
	unlisted = []

	lists_min.each do |list|
		begin
			host = check+'.'+list
			#puts host
			Resolv.getaddress(host)
			listed << list
		rescue Resolv::ResolvError
			unlisted << list
		end
	end
	
	{:listed => listed, :unlisted => unlisted}
  end
end
