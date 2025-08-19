{config, ...}: let
  inherit (config.networking) fqdn;
  grafanaDomain = "grafana.${config.networking.domain}";
in {
  security.acme.certs.${fqdn}.extraDomainNames = [grafanaDomain];

  services.grafana = {
    enable = true;
    settings.server.domain = grafanaDomain;
  };

  services.nginx = {
    upstreams.grafana.servers."localhost:${toString config.services.grafana.settings.server.http_port}" = {};
    virtualHosts.${grafanaDomain} = {
      locations."/" = {
        proxyPass = "http://grafana";
        proxyWebsockets = true;
        recommendedProxySettings = true;
      };
      onlySSL = true;
      useACMEHost = fqdn;
    };
  };
}
