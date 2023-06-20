{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./filesystem.nix
    ./mailserver.nix
    ./named.nix
    ./netbox.nix
    ./network.nix
    ./services.nix
  ];

  boot.initrd.availableKernelModules = ["ata_piix" "uhci_hcd" "virtio_pci" "virtio_blk"];
  boot.loader.grub = {
    enable = true;
    device = "/dev/vda";
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

  sops = {
    defaultSopsFile = ./secrets.yaml;
    age.sshKeyPaths = ["/var/lib/ssh/ssh_host_ed25519_key"];
  };

  system.activationScripts.persistent-directories = ''
    mkdir -pm 0755 /var/lib/ssh
  '';
}
