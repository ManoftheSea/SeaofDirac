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
      include "${config.sops.secrets.rndc_key.path}";
      include "${config.sops.secrets.named_conf.path}";
    '';

    zones = {
      "seaofdirac.org" = {
        file = "/var/dns/seaofdirac.org.db";
        master = true;
        slaves = ["homenets"];
        extraConfig = "allow-update { key aluminium; };";
      };
    };
  };

  sops.secrets.rndc_key.owner = config.users.users.named.name;
  sops.secrets.named_conf.owner = config.users.users.named.name;
}
