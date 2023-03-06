{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./filesystem.nix
    ./network.nix
    ./services.nix
  ];

  boot.initrd.availableKernelModules = ["ata_piix" "uhci_hcd" "virtio_pci" "virtio_blk"];
  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "/dev/vda";
  };

  environment = {
    etc."machine-id".text = "8eb3bde8fc964dde8a6437eb5c526900";
    systemPackages = builtins.attrValues {
      inherit
        (pkgs)
        vim
        ;
    };
  };

  hardware.enableRedistributableFirmware = true;

  system.activationScripts.persistent-directories = ''
    mkdir -pm 0755 /var/lib/ssh
  '';
}
