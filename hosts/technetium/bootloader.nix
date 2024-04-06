{pkgs, ...}: {
  boot = {
    binfmt.emulatedSystems = ["aarch64-linux"];
    # binfmt.registrations.aarch64-linux.fixBinary = true;
    initrd = {
      availableKernelModules = [
        "ahci"
        "ehci_pci"
        "raid1"
        "sd_mod"
        "sr_mod"
        "usbhid"
        "usb_storage"
        "xhci_pci"
      ];
      kernelModules = [
        "dm-raid"
        "dm-integrity"
      ];
    };

    kernelModules = ["kvm-intel"];
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [];
    extraModulePackages = [];
  };
}
