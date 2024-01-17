{pkgs, ...}: {
  boot = {
    initrd = {
      availableKernelModules = [
        "ahci"
        "sd_mod"
        "sdhci_pci"
        "uas"
        "usbhid"
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
      # "zswap.enabled=1"
      # "zswap.compressor=zstd"
      # "zswap.zpool=z3fold"
    ];
    extraModulePackages = [];
  };
}
