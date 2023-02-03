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
        vim
        wget
        ;
    };
  };

  hardware.enableRedistributableFirmware = true;

  services.openssh = {
    hostKeys = [
      {
        path = "/var/lib/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];
  };

  system.activationScripts.persistent-directories = ''
    mkdir -pm 0755 /var/lib/ssh
  '';
}
