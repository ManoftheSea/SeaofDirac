{config, ...}: let
  hostName = "technetium.seaofdirac.org";
  grafanaDomain = "grafana.seaofdirac.org";
in {
  security.acme.certs.${hostName}.extraDomainNames = [
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
    useACMEHost = hostName;
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString config.services.grafana.port}";
      proxyWebsockets = true;
      recommendedProxySettings = true;
    };
  };
}
