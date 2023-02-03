{
  config,
  lib,
  suites,
  profiles,
  pkgs,
  ...
}: {
  imports =
    suites.laptop
    ++ [
      profiles.usbguard
      profiles.graphical.intel-gpu
      profiles.graphical.plasma5
      profiles.audio.pipewire
      profiles.hardware.virt-manager
    ];

  boot = {
    binfmt.emulatedSystems = ["aarch64-linux"];
    binfmt.registrations.aarch64-linux.fixBinary = true;

    initrd = {
      availableKernelModules = ["xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod"];
      kernelModules = [];
    };

    kernelModules = ["kvm-intel"];
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = ["module_blacklist=hid_sensor_hub"];
    extraModulePackages = [];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/9ef1549f-25e3-4e22-a60b-cb10ae840130";
      fsType = "ext4";
    };

    "/efi" = {
      device = "/dev/disk/by-uuid/9E84-0C07";
      fsType = "vfat";
    };
  };

  swapDevices = [];

  hardware = {
    cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

    sane.enable = true;

    video.hidpi.enable = true;
  };

  networking.hostName = "aluminium";

  services = {
    avahi.enable = true;
    fwupd.enable = true;

    power-profiles-daemon.enable = false;

    printing.enable = true;
  };

  environment = {
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
  };

  security.polkit.enable = true;
}
