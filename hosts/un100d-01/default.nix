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
    ./services
    ./unfree.nix
  ];

  environment = {
    etc."machine-id".text = "01ce177722f6437f984899b1a004e251";
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
  };

  system.stateVersion = "25.05"; # Netbox
  time.timeZone = "UTC";

  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  zramSwap.enable = true;
}
