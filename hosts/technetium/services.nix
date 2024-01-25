{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./kea.nix
    ./nextcloud.nix
    ./nginx.nix
    ./tftp.nix
  ];

  networking.firewall.allowedTCPPorts = [8080];

  services = {
    fstrim.enable = true;

    nix-serve = {
      enable = true;
      port = 8080;
      secretKeyFile = config.sops.secrets.nix_build_key.path;
    };

    openssh = {
      enable = true;
      hostKeys = [
        {
          path = "/var/lib/ssh/ssh_host_ed25519_key";
          type = "ed25519";
        }
      ];
    };

    postgresql = {
      enable = true;
      package = pkgs.postgresql_15;
    };
  };
}
