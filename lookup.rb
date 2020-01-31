def get_command_line_argument
 if ARGV.empty?
   puts "enter a domain name"
   exit
 else
   return ARGV.first
 end
end

def resolve(lookup_chain,domain)
 if $A_dns_records.include?(domain)
  lookup_chain.push($A_dns_records[domain])
  return lookup_chain
 elsif $C_dns_records.include?(domain)
  lookup_chain.push($C_dns_records[domain])
  return resolve(lookup_chain,$C_dns_records[domain])
 else
  puts "no records matched for #{domain}"
  exit
 end
end

def parse_dns(dns_raw)
 dns=[]
 for i in dns_raw
   dns.push(i.split(','))
 end
 for i in 0...dns.length
  for j in 0...dns[i].length  
    dns[i][j]=dns[i][j].to_s.strip
    dns[i][j]=dns[i][j].chomp
    if dns[i][0]=='A'
      $A_dns_records[dns[i][1]]=dns[i][2]    #created hash for A record
    else
      $C_dns_records[dns[i][1]]=dns[i][2]   #created hash for CNAME record 
    end
  end
 end
end

$A_dns_records={}
$C_dns_records={}
domain=get_command_line_argument     		#getting input as command line argument
lookup_chain=[domain]              
dns_raw=File.readlines("zone.txt")   		#reading the zone file line by line 
parse_dns(dns_raw)                              
lookup_chain=resolve(lookup_chain,domain)       #searching recursively
puts lookup_chain.join(" => ")









