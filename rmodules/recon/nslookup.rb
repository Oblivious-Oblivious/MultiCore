require "net/dns"

def main1
    # Basic DNS Loopkup
    resolver = Net::DNS::Resolver.start("google.com");

    puts resolver;
    puts resolver.header;
    puts resolver.question;
    puts resolver.answer;
    puts resolver.authority
    puts resolver.additional;
    puts; puts;
end

def main2
    # MX Lookup
    mx = Net::DNS::Resolver.start("google.com", Net::DNS::MX).answer;
    puts mx;
    puts; puts;
end

def main3
    # ALL Lookup
    any = Net::DNS::Resolver.start("facebook.com", Net::DNS::ANY).answer;
    puts; puts;
end

def main4
    # Reverse Lookup
    resolver = Net::DNS::Resolver.new;
    query = resolver.query("69.171.239.12", Net::DNS::PTR);
    puts; puts;
end

def main5
    # Nameservers
    resolver = Net::DNS::Resolver.new(:nameserver => "8.8.8.8");
    resolver.nameservers = ["8.8.4.4", "8.8.8.8"];
    puts; puts;
end

main1;
main2;
main3;
main4;
main5;
