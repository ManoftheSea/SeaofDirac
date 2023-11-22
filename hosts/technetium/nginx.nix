{config, ...}: {
  networking.firewall.allowedTCPPorts = [80 443];

  security.acme.certs."technetium.seaofdirac.org".group = config.services.nginx.group;

  services.nginx = {
    clientMaxBodySize = "25m";
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
  };
}
