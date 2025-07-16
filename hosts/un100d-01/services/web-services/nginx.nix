{config, ...}: let
  fqdn = "${config.networking.hostName}.seaofdirac.org";
in {
  networking.firewall.allowedTCPPorts = [80 443];
  security.acme.certs."${fqdn}".group = config.services.nginx.group;

  services.nginx = {
    enable = true;
    clientMaxBodySize = "25m";
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
  };

  sops.secrets.rfc2136_secret = {};
  systemd.services.nginx.serviceConfig.SupplementaryGroups = [config.users.groups.netbox.name];
}
