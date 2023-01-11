{ config, pkgs, ... }:

{
  services = {
    usbguard = {
      enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    usbutils
  ];
}
