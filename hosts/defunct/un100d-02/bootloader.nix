{pkgs, ...}: {
  boot = {
    binfmt.emulatedSystems = ["aarch64-linux"];
    initrd = {
      availableKernelModules = [
        "usb_storage"
        "xhci_pci"
      ];
    };

    kernelModules = ["kvm-intel"];
    kernelPackages = pkgs.linuxPackages_latest;
  };
}
