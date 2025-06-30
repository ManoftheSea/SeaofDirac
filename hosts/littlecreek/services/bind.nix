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
      include "${config.sops.secrets."bind/acme_keys".path}";
      include "${config.sops.secrets."bind/rndc_keys".path}";
      include "${config.sops.secrets."bind/config/acls".path}";
      include "${config.sops.secrets."bind/config/controls".path}";
    '';

    listenOn = ["!127.0.0.0/8" "any"];
    listenOnIpv6 = ["!::1" "any"];

    zones = {
      "${config.networking.domain}" = {
        file = "/var/dns/${config.networking.domain}.db";
        master = true;
        slaves = [
          "homenets"
          "216.126.233.180"
          "2606:a8c0:3:35c::/64"
        ];
        extraConfig = ''
          update-policy {
            grant aluminium zonesub any;
            grant castor.seaofdirac.org. name _acme-challenge.castor.seaofdirac.org. TXT;
            grant crunchbits.seaofdirac.org. name _acme-challenge.crunchbits.seaofdirac.org. TXT;
            grant gravity.seaofdirac.org. name gravity.seaofdirac.org. ANY;
            grant gravity.seaofdirac.org. name _acme-challenge.gravity.seaofdirac.org. TXT;
            grant littlecreek.seaofdirac.org. name _acme-challenge.littlecreek.seaofdirac.org. TXT;
            grant littlecreek.seaofdirac.org. name _acme-challenge.mta-sts.seaofdirac.org. TXT;
            grant pollux.seaofdirac.org. name _acme-challenge.pollux.seaofdirac.org. TXT;
            grant singularity.seaofdirac.org. name _acme-challenge.element.seaofdirac.org. TXT;
            grant singularity.seaofdirac.org. name _acme-challenge.jitsi.seaofdirac.org. TXT;
            grant singularity.seaofdirac.org. name _acme-challenge.matrix.seaofdirac.org. TXT;
            grant singularity.seaofdirac.org. name _acme-challenge.singularity.seaofdirac.org. TXT;
            grant singularity.seaofdirac.org. name _acme-challenge.seaofdirac.org. TXT;
            grant un100d-01.seaofdirac.org. name _acme-challenge.un100d-01.seaofdirac.org. TXT;
            grant un100d-02.seaofdirac.org. name _acme-challenge.un100d-02.seaofdirac.org. TXT;
          };
        '';
      };
    };
  };

  sops.secrets =
    lib.genAttrs [
      "bind/acme_keys"
      "bind/rndc_keys"
      "bind/config/acls"
      "bind/config/controls"
    ] (_: {
      owner = config.users.users.named.name;
    });
}
