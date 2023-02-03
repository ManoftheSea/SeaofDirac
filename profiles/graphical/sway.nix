{
  config,
  pkgs,
  ...
}: {
  environment.defaultPackages = builtins.attrValues {
    inherit
      (pkgs)
      grim
      slurp
      swappy
      swayidle
      swaylock
      wdisplays
      wev
      wf-recorder
      wl-clipboard
      wofi
      ;
  };

  programs.sway.enable = true;
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
