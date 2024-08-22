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

    kernelModules = ["kvm-intel"];
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = ["module_blacklist=hid_sensor_hub"];
  };
}
