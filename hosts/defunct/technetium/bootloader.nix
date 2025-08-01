{pkgs, ...}: {
  boot = {
    binfmt.emulatedSystems = ["aarch64-linux"];
    # binfmt.registrations.aarch64-linux.fixBinary = true;
    initrd = {
      availableKernelModules = [
        "raid1"
        "usb_storage"
        "xhci_pci"
      ];
      kernelModules = [
        "dm-raid"
        "dm-integrity"
        "raid10"
      ];
    };

    kernelModules = ["kvm-intel"];
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [];
    extraModulePackages = [];
  };
}
