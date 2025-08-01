{config, ...}: {
  networking.firewall.allowedTCPPorts = [80 443];

  security.acme.certs."${config.networking.fqdn}" = {
    dnsProvider = "rfc2136";
    inherit (config.services.nginx) group;
    webroot = null;
  };

  services.nginx = {
    clientMaxBodySize = "25m";
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;

    virtualHosts."${config.networking.fqdn}" = {
      http2 = true;
      enableACME = true;
      forceSSL = false;
      root = "/var/lib/tftp";
    };
  };
}
