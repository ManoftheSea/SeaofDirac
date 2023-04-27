{
  config,
  pkgs,
  ...
}: {
  networking.firewall.allowedTCPPorts = [];
  networking.firewall.allowedUDPPorts = [69 547];

  services.kea.dhcp6 = {
    enable = true;
    settings = {
      interfaces-config.interfaces = ["wan/fd50:63ed:f2b7:20::3"];
      lease-database = {
        type = "memfile";
      };
      option-data = [
        {
          name = "unicast";
          data = "fd50:63ed:f2b7:20::3";
        }
        {
          name = "dns-servers";
          data = "fd50:63ed:f2b7::5";
        }
        {
          name = "domain-search";
          data = "seaofdirac.org";
        }
        {
          name = "sntp-servers";
          data = "fd50:63ed:f2b7::5";
        }
        # {
        #   name = "bootfile-url";
        #   data = "https://URI";
        # }
        {
          name = "new-posix-timezone";
          data = "EST5EDT\\,M3.2.0\\,M11.1.0";
        }
        {
          name = "new-tzdb-timezone";
          data = "America/New_York";
        }
      ];
      preferred-lifetime = 3000;
      rebind-timer = 2000;
      renew-timer = 1000;
      subnet6 = [
        {
          interface = "wan";
          rapid-commit = true;
          subnet = "fd50:63ed:f2b7:20::/64";
        }
        {
          interface-id = "vlan30";
          pools = [
            {
              pool = "2601:5cd:c101:5383::cafe:0/112";
            }
          ];
          subnet = "2601:5cd:c101:5383::/64";
        }
        {
          interface-id = "vlan30";
          pd-pools = [
            {
              prefix = "fd50:63ed:f2b7:100::";
              prefix-len = 56;
              delegated-len = 60;
            }
          ];
          subnet = "fd50:63ed:f2b7:30::/64";
        }
      ];
      valid-lifetime = 4000;
    };
  };

  systemd.services = {
    "tftp-hpa" = {
      serviceConfig = {
        ExecStart = "${pkgs.tftp-hpa}/bin/in.tftpd -L -c -s /var/lib/tftp";
      };
      wantedBy = ["multi-user.target"];
    };
  };
}
