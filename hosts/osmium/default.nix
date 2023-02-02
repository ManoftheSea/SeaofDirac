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
      profiles.impermanence
    ];

  boot = {
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
      device = "none";
      fsType = "tmpfs";
      options = ["defaults" "size=2G" "mode=755"];
    };
    "/nix" = {
      device = "/dev/disk/by-label/nix_store";
      fsType = "ext4";
    };
    "/var" = {
      device = "/dev/disk/by-label/var-usb";
      fsType = "ext4";
    };
    "/home" = {
      device = "/dev/disk/by-label/home-usb";
      fsType = "ext4";
    };
    "/efi" = {
      device = "/dev/disk/by-label/ESP-USB";
      fsType = "vfat";
    };
  };

  swapDevices = [];

  hardware = {
    cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

    sane.enable = true;

    video.hidpi.enable = true;
  };

  networking.hostName = "osmium";

  services = {
    avahi.enable = true;
    fwupd.enable = true;

    power-profiles-daemon.enable = false;

    printing.enable = true;
  };

  users = {
    mutableUsers = false;
    users = {
      localadmin = {
        isNormalUser = true;
        extraGroups = ["wheel" "networkmanager" "video" "audio" "dialout"]; # Enable ‘sudo’ for the user.
        initialPassword = "hunter2";
        packages = with pkgs; [
          firefox
        ];
      };
    };
  };

  environment = {
    etc = {
      "machine-id".text = "79a69c13c47946b987cbee878d43745b";
    };
    systemPackages = with pkgs; [
      deploy-rs
      git
      home-manager
      minicom
      tree
      wget
    ];
    variables = {
      EDITOR = "nvim";
    };
  };

  programs = {
    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
    };
  };
}
