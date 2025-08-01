{
  services.kea.dhcp-ddns = {
    enable = true;
    settings = {
      forward-ddns.ddns-domains = [
        {
          name = "users.seaofdirac.org.";
          key-name = "ddns.technetium.seaofdirac.org.";
          dns-servers = [
            {ip-address = "192.168.200.5";}
          ];
        }
      ];
      reverse-ddns.ddns-domains = [
        {
          name = "168.192.in-addr.arpa.";
          key-name = "ddns.technetium.seaofdirac.org.";
          dns-servers = [
            {ip-address = "192.168.200.5";}
          ];
        }
      ];
      tsig-keys = [
        {
          name = "ddns.technetium.seaofdirac.org.";
          algorithm = "HMAC-SHA256";
          secret = "u6txrOy4GW+8kj4pjNL0kWvbEDmgZuT5LONJKcI1A2k="; # Warning, keymat leaked!
        }
      ];
    };
  };
}
