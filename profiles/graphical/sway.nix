{ config, pkgs, ... }:

{
  environment.defaultPackages = with pkgs; [
    grim
    slurp
    swappy
    swayidle
    swaylock
    wdisplays
    wev
    wf-recorder
    wf-clipboard
    wofi
  ];

  programs.sway.enable = true;
  # environment.sessionVariables.NIXOS_OZONE_WL = "1";

  wayland.windowManager.sway = {
    enable = true;
    config = {
      # Lots of stuff to customize here
    };
  };
}
