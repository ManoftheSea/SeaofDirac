{
  config,
  pkgs,
  nixos,
  nixos-hardware,
  ...
}: {
  imports = [
    ./filesystem.nix
    ./prometheus.nix
  ];

  boot = {
    binfmt.emulatedSystems = ["aarch64-linux"];
    binfmt.registrations.aarch64-linux.fixBinary = true;

    initrd = {
      availableKernelModules = [
        "nvme"
        "sd_mod"
        "thunderbolt"
        "uas"
        "usb_storage"
        "xhci_pci"
        # "z3fold"
        # "zstd"
      ];
      kernelModules = [];
    };

    kernelModules = ["kvm-intel"];
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      "module_blacklist=hid_sensor_hub"
      # "zswap.enabled=1"
      # "zswap.compressor=zstd"
      # "zswap.zpool=z3fold"
    ];
    extraModulePackages = [];
  };

  hardware = {
    cpu.intel.updateMicrocode = nixos.lib.mkDefault config.hardware.enableRedistributableFirmware;

    sane = {
      enable = true;
      extraBackends = [pkgs.hplip];
    };
    usb-modeswitch.enable = true;
  };

  networking.hostName = "aluminium";
  networking.nftables.enable = true;

  services = {
    avahi = {
      enable = true;
      nssmdns = true;
      openFirewall = true;
    };
    fwupd.enable = true;
    hardware.bolt.enable = true;
    pcscd.enable = true;
    power-profiles-daemon.enable = false;
    printing.enable = true;
  };

  environment = {
    etc = {
      "machine-id".text = "2904306768fd4a8185f3660916616816";
    };
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

  programs = {
    dconf.enable = true;
    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
    };
    sway.enable = true;
  };

  security.polkit.enable = true;

  system.stateVersion = "23.11";

  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
  virtualisation.docker.enable = true;

  zramSwap.enable = true;
  # zramSwap.memoryPercent = 50;
}
