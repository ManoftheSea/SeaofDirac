{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./bootloader.nix
    ./disko.nix
    ./network.nix
    ./services.nix
    ./unfree.nix
  ];

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
    /*
    # Xeon doesn't have GPU, does it have hardware encoders?
    opengl = {
      enable = true;
      extraPackages = builtins.attrValues {
        inherit
          (pkgs)
          intel-media-driver
          vaapiIntel
          vaapiVdpau
          libvdpau-va-gl
          intel-compute-runtime
          ;
      };
    };
    */
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

  system.stateVersion = "24.05";
  time.timeZone = "UTC";

  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  zramSwap.enable = true;
}
