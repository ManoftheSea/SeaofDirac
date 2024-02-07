{pkgs, ...}: {
  services = {
    avahi = {
      enable = true;
      nssmdns = true;
      openFirewall = true;
    };
    hardware.bolt.enable = true;
    openssh.enable = true;
    pcscd.enable = true;
    power-profiles-daemon.enable = false;
    printing = {
      enable = true;
      drivers = [pkgs.hplip];
    };
    resolved.enable = true;

    xserver = {
      enable = true;
      desktopManager.plasma5.enable = true;
      displayManager.sddm.enable = true;
      libinput.enable = true;
    };
  };
}
