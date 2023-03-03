{
  config,
  pkgs,
  nixos,
  nixos-hardware,
  ...
}: {
  imports = [
    ./filesystem.nix
  ];

  boot = {
    binfmt.emulatedSystems = ["aarch64-linux"];
    binfmt.registrations.aarch64-linux.fixBinary = true;

    initrd = {
      availableKernelModules = [
        "nvme"
        "sd_mod"
        "thunderbolt"
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

    sane.enable = true;

    video.hidpi.enable = true;
  };

  networking.hostName = "aluminium";

  services = {
    avahi.enable = true;
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
        git
        home-manager
        minicom
        wget
        ;
    };
  };

  programs = {
    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
    };
    sway.enable = true;
  };

  security.polkit.enable = true;

  zramSwap.enable = true;
  # zramSwap.memoryPercent = 50;
}
