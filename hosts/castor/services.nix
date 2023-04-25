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
      interfaces-config.interfaces = ["wan"];
      option-data = [
        {
          name = "dns-servers";
          data = "fd50:63ed:f2b7::5";
        }
        {
          name = "domain-search";
          data = "seaofdirac.org";
        }
        {
          name = "new-posix-timezone";
          data = "EST5EDT\\,M3.2.0\\,M11.1.0";
        }
        {
          name = "new-tzdb-timezone";
          data = "America/New_York";
        }
      ];
      lease-database = {
        type = "memfile";
      };
    };
  };

  systemd.services = {
    "tftp-hpa" = {
      serviceConfig = {
        ExecStart = "${pkgs.tftp-hpa}/bin/in.tftpd -L -c -s /srv/tftp";
      };
      wantedBy = ["multi-user.target"];
    };
  };
}
