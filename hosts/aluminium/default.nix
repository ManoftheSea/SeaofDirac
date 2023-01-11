{ config, lib, suites, profiles, pkgs, ... }:

{
  imports = suites.laptop ++ [ ./usbguard-rules.nix ];

  boot = {
    binfmt.emulatedSystems = [ "aarch64-linux" ];

    initrd = {
      availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" ];
      kernelModules = [ ];
    };

    kernelModules = [ "kvm-intel" ];
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [ "module_blacklist=hid_sensor_hub" ];
    extraModulePackages = [ ];

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

  swapDevices = [ ];

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };

    cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

    opengl = {
      enable = true;
      extraPackages = with pkgs; [
        vaapiIntel
        vaapiVdpau
        libvdpau-va-gl
        intel-media-driver
      ];
    };

    pulseaudio = {
      enable = true;
      package = pkgs.pulseaudioFull;
    };

    sane.enable = true;
  };

  networking = {
    useDHCP = lib.mkDefault true;
    hostName = "aluminium";
    networkmanager.enable = true; # Easiest to use and most distros use this by default.
  };

  services = {
    avahi.enable = true;
    fwupd.enable = true;

    power-profiles-daemon.enable = false;

    printing.enable = true;

    tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      };
    };

    xserver = {
      enable = true;
      layout = "us";

      displayManager.sddm.enable = true;
      desktopManager.plasma5.enable = true;
    };

  };

  # Enable sound.
  sound.enable = true;

  users.users = {
    localadmin = {
      isNormalUser = true;
      home = "/home/localadmin";
      extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
      packages = with pkgs; [
        firefox
      ];
    };
  };

  environment = {
    systemPackages = with pkgs; [
      deploy-rs
      file
      gptfdisk
      git
      home-manager
      minicom
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

