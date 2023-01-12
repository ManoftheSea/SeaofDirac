{ config, ... }:

{
  documentation.enable = false;

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
