{
  config,
  lib,
  ...
}: let
  genGrantToSelfStrings = host: "    grant ${host}.seaofdirac.org. name _acme-challenge.${host}.seaofdirac.org. TXT;\n";
in {
  environment.systemPackages = lib.mkIf config.services.bind.enable [config.services.bind.package];

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
      include "${config.sops.secrets."bind/keys/acme-challenge".path}";
      include "${config.sops.secrets."bind/keys/rndc".path}";
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
          "216.158.230.86"
          "2604:a00:50:210:216:3eff:fe2f:8f09"
        ];
        extraConfig =
          ''
            dnssec-policy default;
            key-directory "/var/dns/DNSSEC-keys/";
            update-policy {
                grant aluminium zonesub any;
                grant gravity.seaofdirac.org. name gravity.seaofdirac.org. ANY;

                grant castor.seaofdirac.org. name _acme-challenge.castor.internal.seaofdirac.org. TXT;
                grant interserver-s01.seaofdirac.org name _acme-challenge.grafana.seaofdirac.org. TXT;
                grant littlecreek.seaofdirac.org. name _acme-challenge.mta-sts.seaofdirac.org. TXT;
                grant littlecreek.seaofdirac.org. name _acme-challenge.seaofdirac.org. TXT;
                grant singularity.seaofdirac.org. name _acme-challenge.element.seaofdirac.org. TXT;
                grant singularity.seaofdirac.org. name _acme-challenge.jitsi.seaofdirac.org. TXT;
                grant singularity.seaofdirac.org. name _acme-challenge.matrix.seaofdirac.org. TXT;
                grant singularity.seaofdirac.org. name _acme-challenge.seaofdirac.org. TXT;
                grant un100d-01.seaofdirac.org. name _acme-challenge.home.seaofdirac.org. TXT;
                grant un100d-01.seaofdirac.org. name _acme-challenge.netbox.seaofdirac.org. TXT;

          ''
          + lib.concatStrings (
            map genGrantToSelfStrings [
              "castor"
              "crunchbits"
              "gravity"
              "interserver-c01"
              "interserver-s01"
              "littlecreek"
              "pollux"
              "singularity"
              "un100d-01"
              "un100d-02"
            ]
          )
          + "  };\n";
      };
    };
  };

  sops.secrets =
    lib.genAttrs [
      "bind/keys/acme-challenge"
      "bind/keys/rndc"
      "bind/config/acls"
      "bind/config/controls"
    ] (_: {
      owner = config.users.users.named.name;
    });
}
