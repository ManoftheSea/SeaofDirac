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
    initrd.availableKernelModules = ["xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod"];
    kernelModules = ["kvm-intel"];
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = ["module_blacklist=hid_sensor_hub"];
  };

  environment = {
    etc."machine-id".text = "79a69c13c47946b987cbee878d43745b";
    systemPackages = builtins.attrValues {
      inherit
        (pkgs)
        git
        home-manager
        tree
        vim
        wget
        ;
    };
  };

  hardware = {
    cpu.intel.updateMicrocode = config.hardware.enableRedistributableFirmware;
    sane.enable = true;
    video.hidpi.enable = true;
  };

  networking.hostName = "osmium";

  security.polkit.enable = true;

  services = {
    avahi.enable = true;
    fwupd.enable = true;
    hardware.bolt.enable = true;
    pcscd.enable = true;
    power-profiles-daemon.enable = false;
    printing.enable = true;
  };

  zramSwap.enable = true;
}
