{
  config,
  lib,
  ...
}: {
  documentation.enable = false;

  nix.gc.options = "--delete-older-than 5d";

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    openFirewall = false;
  };
}
