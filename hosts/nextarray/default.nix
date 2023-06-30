{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./filesystem.nix
    ./network.nix
    ./services.nix
    ./ldap.nix
  ];

  boot.initrd.availableKernelModules = ["ata_piix" "uhci_hcd" "virtio_pci" "virtio_blk"];
  boot.loader.grub = {
    enable = true;
    device = "/dev/vda";
    extraEntries = ''
      menuentry "Netboot.xyz - gPXE" --class netboot --unrestricted {
        linux16 ($drive1)//netboot.xyz.lkrn
      }
    '';
    ipxe = {
      "Netboot" = ''
        #!ipxe
        dhcp
        chain --autofree https://boot.netboot.xyz
      '';
    };
  };

  environment = {
    etc."machine-id".text = "8eb3bde8fc964dde8a6437eb5c526900";
    # noXlibs = true;
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
