{pkgs, ...}: {
  services = {
    avahi = {
      enable = true;
      nssmdns4 = true;
      nssmdns6 = true;
      openFirewall = true;
    };
    fwupd.enable = true;
    hardware.bolt.enable = true;
    pcscd.enable = true;
    power-profiles-daemon.enable = false;
    printing = {
      enable = true;
      drivers = [pkgs.hplip];
    };
    resolved.enable = true;
    udev.extraRules = ''
      # Elecom Mouse
      ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="056e", ATTR{idProduct}=="00fe", ATTR{power/autosuspend}="-1"
    '';
  };
}
