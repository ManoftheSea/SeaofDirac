{
  config,
  lib,
  ...
}: {
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
      include "${config.sops.secrets."bind/acme_keys/crunchbits".path}";
      include "${config.sops.secrets."bind/acme_keys/gravity".path}";
      include "${config.sops.secrets."bind/acme_keys/littlecreek".path}";
      include "${config.sops.secrets."bind/acme_keys/singularity".path}";
      include "${config.sops.secrets."bind/acme_keys/technetium".path}";
      include "${config.sops.secrets."bind/rndc_keys/aluminium".path}";
      include "${config.sops.secrets."bind/config/acls".path}";
      include "${config.sops.secrets."bind/config/controls".path}";
    '';

    zones = {
      "${config.networking.domain}" = {
        file = "/var/dns/${config.networking.domain}.db";
        master = true;
        slaves = [
          "homenets"
          "38.175.192.169"
          "2606:a8c0:3::348"
          "2606:a8c0:3:35c::/64"
        ];
        extraConfig = ''
          update-policy {
            grant aluminium zonesub any;
            grant crunchbits.seaofdirac.org. name _acme-challenge.crunchbits.seaofdirac.org. TXT;
            grant gravity.seaofdirac.org. name gravity.seaofdirac.org. ANY;
            grant gravity.seaofdirac.org. name _acme-challenge.gravity.seaofdirac.org. TXT;
            grant littlecreek.seaofdirac.org. name _acme-challenge.littlecreek.seaofdirac.org. TXT;
            grant littlecreek.seaofdirac.org. name _acme-challenge.mta-sts.seaofdirac.org. TXT;
            grant singularity.seaofdirac.org. name _acme-challenge.singularity.seaofdirac.org. TXT;
            grant singularity.seaofdirac.org. name _acme-challenge.element.seaofdirac.org. TXT;
            grant singularity.seaofdirac.org. name _acme-challenge.matrix.seaofdirac.org. TXT;
            grant singularity.seaofdirac.org. name _acme-challenge.seaofdirac.org. TXT;
            grant technetium.seaofdirac.org. name _acme-challenge.technetium.seaofdirac.org. TXT;
            grant technetium.seaofdirac.org. name _acme-challenge.grafana.seaofdirac.org. TXT;
            grant technetium.seaofdirac.org. name _acme-challenge.nextcloud.seaofdirac.org. TXT;
          };
        '';
      };
    };
  };

  sops.secrets =
    lib.genAttrs [
      "bind/acme_keys/crunchbits"
      "bind/acme_keys/gravity"
      "bind/acme_keys/littlecreek"
      "bind/acme_keys/singularity"
      "bind/acme_keys/technetium"
      "bind/rndc_keys/aluminium"
      "bind/config/acls"
      "bind/config/controls"
    ] (_: {
      owner = config.users.users.named.name;
    });
}
