{config, ...}: let
  inherit (config.networking) fqdn;
in {
  services.nginx = {
    upstreams.loki.servers."localhost:${toString config.services.loki.configuration.server.http_listen_port}" = {};
    virtualHosts.${fqdn} = {
      enableACME = true;
      locations."/" = {
        extraConfig = ''
          allow 73.31.234.197;
          allow 2601:5cc:4a01:6fa0::/60;
          deny  all;
        '';
        proxyPass = "http://loki";
        proxyWebsockets = true;
        recommendedProxySettings = true;
      };
      onlySSL = true;
    };
  };
}
