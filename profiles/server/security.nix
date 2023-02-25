{config, ...}: {
  nix.settings.allowed-users = ["root"];
  security.sudo.enable = false;
  services.openssh.extraConfig = ''
    AllowTcpForwarding no
    AllowAgentForwarding no
    AllowStreamLocalForwarding no
  '';
}
