{config, ...}: {
  networking.firewall.allowedTCPPorts = [80 443];

  services = {
    avahi = {
      enable = true;
      nssmdns = true;
      openFirewall = true;
    };
    fwupd.enable = true;
    openssh.enable = true;
    power-profiles-daemon.enable = false;
    tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "ondemand";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      };
    };

    printing.enable = true;
  };
}
