{config, ...}: let
  # inherit (config.networking) domain fqdn;
  domain = "seaofdirac.org";
  fqdn = "${config.networking.hostName}.${domain}";
  hostnameForHA = "home";
in {
  security.acme.certs."${fqdn}".extraDomainNames = ["${hostnameForHA}.${domain}"];

  services = {
    ddclient = {
      enable = true;
      domains = ["${hostnameForHA}.${domain}"];
      passwordFile = config.sops.secrets.ddclient.path;
      protocol = "nsupdate";
      server = "ns1.seaofdirac.org";
      usev4 = "";
      usev6 = "webv6, webv6=ipify-ipv6";
      zone = "seaofdirac.org";
    };

    home-assistant = {
      enable = true;
      config = {
        default_config = {};
        http = {
          server_host = "::1";
          trusted_proxies = ["::1"];
          use_x_forwarded_for = true;
        };
        recorder.db_url = "postgresql://@/hass";
      };
      extraComponents = [
        # Components required to complete the onboarding
        "analytics"
        "esphome"
        "google_translate"
        "isal"
        "met"
        "radio_browser"
        "shopping_list"
        "zwave_js"
      ];
      extraPackages = p: [p.psycopg2];
    };

    nginx.virtualHosts."${hostnameForHA}.${domain}" = {
      extraConfig = ''
        proxy_buffering off;
      '';
      locations."/" = {
        proxyPass = "http://[${config.services.home-assistant.config.http.server_host}]:${builtins.toString config.services.home-assistant.config.http.server_port}";
        proxyWebsockets = true;
      };
      forceSSL = true;
      useACMEHost = fqdn;
    };
  };

  sops.secrets.ddclient = {};
}
