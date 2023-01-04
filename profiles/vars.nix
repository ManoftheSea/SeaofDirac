{ self, config, pkgs, ... }:

{
  vars = rec {
    email = "contact@seaofdirac.org";
    username = "derek";
    terminal = "alacritty";
    terminalBin = "${pkgs.alacritty}/bin/alacritty";

    sshPublicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAQjiOPTrTj3EUfLI0DwzFRTSDboiaznFKRsiovuSS76 derek@aluminium";

    timezone = "America/New_York";

  };
}
