{lib, ...}: {
  nix.settings.allowed-users = ["root"];
  security.sudo.enable = lib.mkDefault false;
  services.openssh.extraConfig = ''
    AllowTcpForwarding no
    AllowAgentForwarding no
    AllowStreamLocalForwarding no
  '';
}
