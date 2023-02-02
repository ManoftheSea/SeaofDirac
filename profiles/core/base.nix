{ config, pkgs, lib, ... }:

{
  boot = {
    cleanTmpDir = lib.mkDefault true;
    tmpOnTmpfs = lib.mkDefault true;
  };

  environment = {
    defaultPackages = with pkgs; [
      dnsutils
      file
      gptfdisk
      less
      pciutils
      psmisc
      tmux
      usbutils
    ];
  };

  nix = {
    gc.automatic = lib.mkDefault true;
    optimise.automatic = lib.mkDefault true;
    settings.auto-optimise-store = lib.mkDefault true;
  };

  security = {
    rtkit.enable = lib.mkDefault true;
  };

  system.stateVersion = lib.mkDefault "22.11";

  time.timeZone = lib.mkDefault "America/New_York";
}
