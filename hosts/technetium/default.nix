{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./disko.nix
    ./network.nix
    ./services.nix
  ];

  boot = {
    initrd = {
      availableKernelModules = [
        "ahci"
        "ehci_pci"
        "raid1"
        "sd_mod"
        "sr_mod"
        "usbhid"
        "usb_storage"
        "xhci_pci"
      ];
      kernelModules = [
        "dm-raid"
        "dm-integrity"
      ];
    };

    kernelModules = ["kvm-intel"];
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [];
    extraModulePackages = [];
  };

  environment = {
    etc."machine-id".text = "f90a55a23b01430b92228b0baa8c1d8e";
    systemPackages = builtins.attrValues {
      inherit
        (pkgs)
        dnsutils
        efibootmgr
        file
        gptfdisk
        ipmitool
        less
        pciutils
        psmisc
        tmux
        usbutils
        vim
        wget
        ;
    };
  };

  hardware = {
    cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    enableRedistributableFirmware = true;
  };

  # Overwrite default
  nix = {
    extraOptions = "secret-key-files = ${config.sops.secrets.nix_build_key.path}";
    gc.options = "";
  };

  sops = {
    defaultSopsFile = ./secrets.yaml;
    age.sshKeyPaths = ["/var/lib/ssh/ssh_host_ed25519_key"];
    secrets = {
      nix_build_key = {};
      rfc2136_secret = {};
    };
  };

  system.activationScripts.persistent-directories = ''
    mkdir -pm 0755 /var/lib/ssh
  '';

  system.stateVersion = "23.11";
  time.timeZone = "UTC";

  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  zramSwap.enable = true;
}
