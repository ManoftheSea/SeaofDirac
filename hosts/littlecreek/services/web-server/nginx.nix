{config, ...}: let
  inherit (config.networking) fqdn;
in {
  networking.firewall.allowedTCPPorts = [80 443];
  security.acme.certs."${fqdn}".group = config.services.nginx.group;

  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
  };

  sops.secrets.rfc2136_secret = {};
}
