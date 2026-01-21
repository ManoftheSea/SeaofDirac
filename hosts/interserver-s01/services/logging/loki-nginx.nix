{config, ...}: let
  inherit (config.networking) fqdn;
in {
  services.nginx = {
    upstreams.loki.servers."localhost:${toString config.services.loki.configuration.server.http_listen_port}" = {};
    virtualHosts.${fqdn} = {
      locations."/" = {
        extraConfig = ''
          allow 73.147.172.220;
          allow 2601:5cc:4a00:61d0::/60;
          deny  all;
        '';
        proxyPass = "http://loki";
        proxyWebsockets = true;
        recommendedProxySettings = true;
      };
      #onlySSL = true;
    };
  };
}
