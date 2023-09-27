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
    extraConfig = ''
      include "${config.sops.secrets."bind/rndc_keys/aluminium".path}";
      include "${config.sops.secrets."bind/config/acls".path}";
      include "${config.sops.secrets."bind/config/controls".path}";
    '';
    extraOptions = ''
      allow-transfer { none; };
    '';

    zones = {
      "seaofdirac.org" = {
        file = "/var/dns/seaofdirac.org.db";
        master = false;
        masters = ["2001:550:5a00:b28c::1"];
      };
    };
  };

  sops.secrets."bind/rndc_keys/aluminium".owner = config.users.users.named.name;
  sops.secrets."bind/config/acls".owner = config.users.users.named.name;
  sops.secrets."bind/config/controls".owner = config.users.users.named.name;
}
