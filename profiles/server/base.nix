{ config, ... }:

{
  documentation.enable = false;

  environment.noXlibs = mkDefault true;

  nix = {
    gc = {
      options = "--delete-older-than 5d";
    };
  };

  services = {
    openssh = {
      enable = true;
      passwordAuthentication = false;
      openFirewall = false;
    };
  };
}
