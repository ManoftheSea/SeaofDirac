{ self, config, pkgs, ... }:

{
  vars = rec {
    email = "contact@seaofdirac.org";
    username = "derek";
    terminal = "alacritty";
    terminalBin = "${pkgs.alacritty}/bin/alacritty";

  };
}
