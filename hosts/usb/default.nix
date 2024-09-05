{
  config,
  modulesPath,
  pkgs,
  ...
}: {
  imports = [
    "${modulesPath}/image/repart.nix"
    "${modulesPath}/profiles/minimal.nix"
    ./partitions.nix
    ./sysupdate.nix
  ];

  boot = {
    enableContainers = false;
    initrd.systemd.enable = true;
    kernelParams = ["console=ttyS0"];
    loader.grub.enable = false;
    tmp.cleanOnBoot = true;
    uki.name = "appliance";
  };

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
        usbutils
        wget
        ;
    };
  };

  fileSystems = {
    "/" = {
      fsType = "tmpfs";
      options = ["size=20%"];
    };
    "/nix/store" = let
      partConf = config.image.repart.partitions."store".repartConfig;
    in {
      fsType = partConf.Format;
      device = "/dev/disk/by-partlabel/${partConf.Label}";
    };
    # Discoverable partitions should enable /efi, /boot, and /var
  };

  networking = {
    useNetworkd = true;
    firewall.enable = false;
  };

  nix.enable = false;

  programs = {
    bash.promptInit = ''
      export PS1="\u@\h (version ${config.system.image.version}) $ "
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

  systemd = {
    network.wait-online.enable = false;
    sysusers.enable = true;
  };

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
  };
}
