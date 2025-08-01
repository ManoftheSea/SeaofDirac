{config, ...}: let
  grafanaDomain = "grafana.${config.networking.domain}";
in {
  security.acme.certs.${config.networking.fqdn}.extraDomainNames = [
    grafanaDomain
  ];

  services.grafana = {
    enable = true;
    settings = {
      server.domain = grafanaDomain;
    };
  };

  services.nginx.virtualHosts.${grafanaDomain} = {
    onlySSL = true;
    useACMEHost = config.networking.fqdn;
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString config.services.grafana.settings.server.http_port}";
      proxyWebsockets = true;
      recommendedProxySettings = true;
    };
  };
}
