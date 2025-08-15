{config, ...}: let
  inherit (config.networking) fqdn;
  grafanaDomain = "grafana.${config.networking.domain}";
in {
  security.acme.certs.${fqdn}.extraDomainNames = [grafanaDomain];

  services.grafana = {
    enable = true;
    settings.server.domain = grafanaDomain;
  };

  services.nginx.virtualHosts.${grafanaDomain} = {
    locations."/" = {
      proxyPass = "http://localhost:${toString config.services.grafana.settings.server.http_port}";
      proxyWebsockets = true;
      recommendedProxySettings = true;
    };
    onlySSL = true;
    useACMEHost = fqdn;
  };
}
