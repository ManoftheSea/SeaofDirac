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
      configFile = "/run/credentials/kea-dhcp4-server.service/dhcpv4.conf";
    };
    dhcp6 = {
      enable = true;
      configFile = "/run/credentials/kea-dhcp6-server.service/dhcpv6.conf";
    };
    dhcp-ddns = {
      enable = true;
      configFile = "/run/credentials/kea-dhcp-ddns-server.service/dhcp-ddns.conf";
    };
  };

  sops.secrets = {
    kea-dhcpv4 = {
      format = "json";
      key = "";
      mode = "0440";
      reloadUnits = ["kea-dhcp4-server.service"];
      sopsFile = ./dhcpv4.json;
    };
    kea-dhcpv6 = {
      format = "json";
      key = "";
      mode = "0440";
      reloadUnits = ["kea-dhcp6-server.service"];
      sopsFile = ./dhcpv6.json;
    };
    kea-ddns = {
      format = "json";
      key = "";
      mode = "0440";
      reloadUnits = ["kea-dhcp-ddns-server.service"];
      sopsFile = ./dhcp-ddns.json;
    };
  };

  systemd.services = {
    kea-dhcp4-server.serviceConfig.LoadCredential = "dhcpv4.conf:${config.sops.secrets.kea-dhcpv4.path}";
    kea-dhcp6-server.serviceConfig.LoadCredential = "dhcpv6.conf:${config.sops.secrets.kea-dhcpv6.path}";
    kea-dhcp-ddns-server.serviceConfig.LoadCredential = "dhcp-ddns.conf:${config.sops.secrets.kea-ddns.path}";
  };
}
