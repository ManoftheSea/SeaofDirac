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
    extraOptions = ''
      allow-transfer { none; };
    '';
    # "dns64", allow-recusion, allow-query
    extraConfig = ''
      include "${config.sops.secrets.rndc_key.path}";
    '';

    zones = {
      "seaofdirac.org" = {
        file = "/var/dns/seaofdirac.org.db";
        master = true;
        # extraConfig = allow-transfer, allow-update
      };
    };
  };

  sops.secrets.rndc_key.owner = config.users.users.named.name;
}
