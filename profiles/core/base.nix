{
  config,
  pkgs,
  lib,
  ...
}: {
  boot.tmp = {
    useTmpfs = lib.mkDefault true;
    cleanOnBoot = lib.mkDefault true;
  };

  environment.defaultPackages = [];

  nix = {
    gc.automatic = lib.mkDefault true;
    gc.options = lib.mkDefault "--delete-older-than 30d";
    optimise.automatic = lib.mkDefault true;
    settings.auto-optimise-store = lib.mkDefault true;
  };

  security.rtkit.enable = lib.mkDefault true;

  system.stateVersion = lib.mkDefault "23.05";

  time.timeZone = lib.mkDefault "America/New_York";
}
