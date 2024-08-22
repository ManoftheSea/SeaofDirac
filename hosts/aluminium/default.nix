{pkgs, ...}: {
  imports = [
    ./bootloader.nix
    ./disko.nix
    ./network.nix
    ./prometheus.nix
    ./services.nix
  ];

  environment = {
    etc."machine-id".text = "2904306768fd4a8185f3660916616816";
    systemPackages = builtins.attrValues {
      inherit
        (pkgs)
        dnsutils
        file
        git
        gptfdisk
        home-manager
        less
        minicom
        nvme-cli
        OVMF
        pciutils
        perl
        psmisc
        rsync
        strace
        tmux
        usbutils
        virt-manager
        wget
        ;
    };
  };

  hardware = {
    sane = {
      enable = true;
      extraBackends = [pkgs.hplip];
    };
    usb-modeswitch.enable = true;
  };

  programs = {
    dconf.enable = true;
    sway.enable = true;
  };

  security.polkit.enable = true;
  systemd.sysusers.enable = true;

  system = {
    etc.overlay = {
      enable = true;
      mutable = false;
    };
    stateVersion = "24.05";
  };

  # users.mutableUsers = false;

  virtualisation = {
    libvirtd.enable = true;
    spiceUSBRedirection.enable = true;
    docker.enable = true;
  };

  zramSwap.enable = true;
}
