{pkgs, ...}: {
  networking.firewall.allowedTCPPorts = [5432];

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_16;
  };
}
