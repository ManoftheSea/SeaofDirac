{
  config,
  modulesPath,
  pkgs,
  ...
}: {
  imports = [
    "${modulesPath}/image/repart.nix"
    "${modulesPath}/profiles/minimal.nix"
    ./network.nix
    ./partitions.nix
    ./sysupdate.nix
  ];

  boot = {
    enableContainers = false;
    initrd = {
      availableKernelModules = [
        "ahci"
        "sd_mod"
        "usbhid"
        "usb_storage"
        "xhci_pci"
      ];
      kernelModules = ["ext4"];
      systemd = {
        enable = true;
        emergencyAccess = true;
      };
    };
    kernelParams = [
      "console=ttyS0,115200"
      "console=tty0"
    ];
    loader.grub.enable = false;
    tmp = {
      cleanOnBoot = true;
      useTmpfs = true;
    };
    uki.name = "collector";
  };

  documentation.enable = false;

  environment = {
    defaultPackages = [];
    etc."machine-id".text = "34cec4c901a444b2b9738c333d500ec2";
    systemPackages = builtins.attrValues {
      inherit
        (pkgs)
        dnsutils
        file
        git
        gptfdisk
        less
        nvme-cli
        pciutils
        psmisc
        tcpdump
        usbutils
        wget
        ;
    };
  };

  fileSystems = {
    # Discoverable partitions should enable /efi, /boot, and /var
    "/" = let
      partConf = config.image.repart.partitions."root".repartConfig;
    in {
      fsType = partConf.Format;
      device = "/dev/disk/by-partlabel/${partConf.Label}";
    };
    "/var" = let
      partConf = config.image.repart.partitions."var".repartConfig;
    in {
      fsType = partConf.Format;
      device = "/dev/disk/by-partlabel/${partConf.Label}";
    };
    "/nix/store" = let
      partConf = config.image.repart.partitions."store".repartConfig;
    in {
      fsType = partConf.Format;
      device = "/dev/disk/by-partlabel/${partConf.Label}";
    };
  };

  hardware = {
    cpu.intel.updateMicrocode = true;
    enableRedistributableFirmware = true;
  };

  networking.hostName = "collector";
  nix.enable = false;

  programs = {
    bash.promptInit = ''
      export PS1="[\u@\h:\w]\$ "
    '';
    command-not-found.enable = false;
    less.lessopen = null;
  };

  security.polkit.enable = true;
  services = {
    getty.autologinUser = "root";
    journald.extraConfig = ''
      SystemMaxUse=10M
    '';
  };

  system = {
    etc.overlay.enable = true;
    image.version = "1";
    stateVersion = "24.05";
    switch.enable = false;
  };

  systemd.sysusers.enable = true;

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
  };
}
