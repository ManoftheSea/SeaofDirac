{
  config,
  lib,
  ...
}: {
  documentation.enable = false;

  environment.noXlibs = lib.mkDefault true;

  nix.gc.options = "--delete-older-than 5d";

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    openFirewall = false;
  };
}
