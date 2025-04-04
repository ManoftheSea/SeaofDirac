{config, ...}: {
  networking.firewall.allowedTCPPorts = [
    8000 # DHCP HA heartbeat
  ];
  networking.firewall.allowedUDPPorts = [
    67 #dhcp
    547 #dhcpv6
  ];

  # These files are "raw json" in SOPS
  # edit them with `sops --output-type json filename.conf
  services.kea = {
    dhcp4 = {
      enable = true;
      #configFile = "/run/credentials/kea-dhcp4-server/dhcpv4.conf";
      configFile = config.sops.secrets.kea-dhcpv4.path;
    };
    dhcp6 = {
      enable = false;
      configFile = config.sops.secrets.kea-dhcpv6.path;
    };
    dhcp-ddns = {
      enable = true;
      configFile = config.sops.secrets.kea-ddns.path;
    };
  };

  sops.secrets = {
    kea-dhcpv4 = {
      format = "json";
      sopsFile = ./dhcpv4.json;
      key = "";
      mode = "0444";
    };
    kea-dhcpv6 = {
      format = "json";
      sopsFile = ./dhcpv6.json;
      key = "";
      mode = "0444";
    };
    kea-ddns = {
      format = "json";
      sopsFile = ./dhcp-ddns.json;
      key = "";
      mode = "0444";
    };
  };

  systemd.services = {
    kea-dhcp4-server.serviceConfig.LoadCredential = "dhcpv4.conf:${config.sops.secrets.kea-dhcpv4.path}";
    kea-dhcp6-server.serviceConfig.LoadCredential = "dhcpv6.conf:${config.sops.secrets.kea-dhcpv6.path}";
    kea-dhcp-ddns-server.serviceConfig.LoadCredential = "dhcpv4.conf:${config.sops.secrets.kea-dhcpv4.path}";
  };
}
