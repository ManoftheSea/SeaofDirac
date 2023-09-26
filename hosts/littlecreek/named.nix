{config, ...}: {
  networking.firewall = {
    allowedTCPPorts = [
      53 # named
      953 # rndc
    ];
    allowedUDPPorts = [
      53 # named
    ];
  };
  services.bind = {
    enable = true;
    cacheNetworks = ["127.0.0.0/24" "::1"];
    extraOptions = ''
      allow-transfer { none; };
    '';
    # "dns64", allow-recusion, allow-query
    extraConfig = ''
      include "${config.sops.secrets."bind/acme_keys/cloudnium".path}";
      include "${config.sops.secrets."bind/acme_keys/gravity".path}";
      include "${config.sops.secrets."bind/acme_keys/littlecreek".path}";
      include "${config.sops.secrets."bind/rndc_keys/aluminium".path}";
      include "${config.sops.secrets."bind/config/acls".path}";
      include "${config.sops.secrets."bind/config/controls".path}";
    '';

    zones = {
      "seaofdirac.org" = {
        file = "/var/dns/seaofdirac.org.db";
        master = true;
        slaves = ["homenets"];
        extraConfig = ''
          update-policy {
            grant aluminium zonesub any;
            grant cloudnium.seaofdirac.org. name _acme-challenge.cloudnium.seaofdirac.org. TXT;
            grant gravity.seaofdirac.org. name gravity.seaofdirac.org. ANY;
            grant littlecreek.seaofdirac.org. name _acme-challenge.littlecreek.seaofdirac.org. TXT;
            grant littlecreek.seaofdirac.org. name _acme-challenge.mta-sts.seaofdirac.org. TXT;
          };
        '';
      };
    };
  };

  sops.secrets."bind/acme_keys/cloudnium".owner = config.users.users.named.name;
  sops.secrets."bind/acme_keys/gravity".owner = config.users.users.named.name;
  sops.secrets."bind/acme_keys/littlecreek".owner = config.users.users.named.name;
  sops.secrets."bind/rndc_keys/aluminium".owner = config.users.users.named.name;
  sops.secrets."bind/config/acls".owner = config.users.users.named.name;
  sops.secrets."bind/config/controls".owner = config.users.users.named.name;
}
