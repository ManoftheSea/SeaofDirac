{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [ ];

  hardware = {
    bluetooth = {
      enable = lib.mkDefault true;
      powerOnBoot = lib.mkDefault true;
    };

    enableRedistributableFirmware = lib.mkDefault true;
  };

  location.provider = "geoclue2";

  networking = {
    useDHCP = false;
    networkmanager.enable = lib.mkDefault true;
  };

  powerManagement.powertop.enable = true; # TODO

  services = {
    avahi = {
      nssmdns = true;
      publish = {
        enable = true;
        addresses = true;
        domain = true;
        userServices = true;
      };
    };
    earlyoom = {
      enable = true;
      enableNotifications = true;
      freeMemThreshold = 5;
    };
    geoclue2.enable = true;
    locate = {
      enable = true;
      interval = "daily";
      locate = pkgs.plocate;
      localuser = null;
    };
    power-profiles-daemon.enable = false; # conflict with tlp
    resolved = {
      extraConfig = ''
        # No need when using Avahi
        MulticastDNS = no
      '';
    };
    tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      };
    };
  };
}
