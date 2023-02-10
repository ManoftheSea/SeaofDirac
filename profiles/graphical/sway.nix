{
  config,
  pkgs,
  ...
}: {
  environment = {
    defaultPackages = builtins.attrValues {
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
    sessionVariables.NIXOS_OZONE_WL = "1";
  };

  programs.sway.enable = true;

  security.pam.services.swaylock = {};
}
