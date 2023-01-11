{ config, lib, suites, profiles, pkgs, ... }:

{
  imports = suites.laptop;

  boot = {
  #  binfmt.emulatedSystems = [ "aarch64-linux" ];

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
      device = "none";
      fsType = "tmpfs";
      options = [ "defaults" "size=2G" "mode=755" ];
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
    hostName = "osmium";
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

  users = {
    mutableUsers = false;
    users = {
      localadmin = {
        isNormalUser = true;
        extraGroups = [ "wheel" "networkmanager" "video" "audio" "dialout" ]; # Enable ‘sudo’ for the user.
	initialPassword = "hunter2";
        packages = with pkgs; [
          firefox
        ];
      };
    };
  };

  environment = {
    # etc."ssh".source symlink to var somehow
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

