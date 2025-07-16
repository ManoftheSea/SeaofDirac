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
    etc."machine-id".text = "cd9e61533dd74f7d8765186fb50285ea";
    systemPackages = builtins.attrValues {
      inherit
        (pkgs)
        dnsutils
        efibootmgr
        file
        gptfdisk
        less
        pciutils
        psmisc
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
    gc.options = "";
  };

  sops = {
    defaultSopsFile = ./secrets.yaml;
    age.sshKeyPaths = ["/var/lib/ssh/ssh_host_ed25519_key"];
    secrets = {
      # rfc2136_secret = {}; # @TODO
    };
  };

  time.timeZone = "UTC";

  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  zramSwap.enable = true;
}
