{pkgs, ...}: {
  services = {
    avahi = {
      enable = true;
      nssmdns4 = true;
      nssmdns6 = true;
      openFirewall = true;
    };
    desktopManager.plasma6.enable = true;
    displayManager.sddm = {
      enable = true;
      theme = "maya";
      wayland.enable = true;
    };
    hardware.bolt.enable = true;
    libinput.enable = true;
    openssh.enable = true;
    pcscd.enable = true;
    power-profiles-daemon.enable = false;
    printing = {
      enable = true;
      drivers = [pkgs.hplip];
    };
    resolved.enable = true;
    udev.extraRules = ''
      # Logitech receivers
      ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="c52b", ATTR{power/autosuspend}="-1"
      ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="c534", ATTR{power/autosuspend}="-1"
    '';
  };
}
