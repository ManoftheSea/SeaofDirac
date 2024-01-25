{
  config,
  pkgs,
  ...
}: {
  boot = {
    # binfmt.emulatedSystems = ["aarch64-linux"];
    # binfmt.registrations.aarch64-linux.fixBinary = true;

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
}
