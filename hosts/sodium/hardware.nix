{
  config,
  pkgs,
  ...
}: {
  boot = {
    initrd = {
      availableKernelModules = [
        "ahci"
        "sd_mod"
        "usbhid"
        "usb_storage"
        "xhci_pci"
      ];
    };

    kernelModules = ["kvm-intel"];
    kernelPackages = pkgs.linuxPackages_latest;
  };

  hardware = {
    bluetooth.enable = true;
    cpu.intel.updateMicrocode = true;
    enableRedistributableFirmware = true;

    sane = {
      enable = true;
      extraBackends = [pkgs.hplip];
    };
  };

  networking.networkmanager.enable = true;
}
