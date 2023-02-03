{
  config,
  pkgs,
  profiles,
  suites,
  ...
}: {
  imports =
    suites.server
    ++ [
      ./filesystem.nix
      ./network.nix
      ./services.nix
    ];

  boot.kernelModules = [];
  boot.loader = {
    efi.canTouchEfiVariables = false;
    grub = {
      enable = true;
      version = 2;
      device = "/dev/vda";
    };
    systemd-boot.enable = false;
  };

  environment = {
    etc."machine-id".text = "5ad95e997a0f413f8770de368bb106ce";
    systemPackages = builtins.attrValues {
      inherit
        (pkgs)
        ndisc6
        tcpdump
        vim
        wget
        ;
    };
  };

  hardware.enableRedistributableFirmware = true;

  system.activationScripts.persistent-directories = ''
    mkdir -pm 0755 /var/lib/ssh
  '';
}
