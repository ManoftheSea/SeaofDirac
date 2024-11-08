{pkgs, ...}: {
  boot = {
    initrd = {
      availableKernelModules = [
        "nvme"
        "sd_mod"
        "thunderbolt"
        "uas"
        "usb_storage"
        "xhci_pci"
      ];
      # systemd.enable = true;
    };

    kernel.sysctl."kernel.dmesg_restrict" = false;
    kernelModules = ["kvm-intel"];
    kernelPackages = pkgs.linuxPackages_latest;
  };
}
