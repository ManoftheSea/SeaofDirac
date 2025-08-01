{pkgs, ...}: {
  imports = [
    ./disko.nix
    ./network.nix
    ./services
  ];

  boot = {
    initrd.availableKernelModules = [
      "ata_piix"
      "sd_mod"
      "sr_mod"
      "uhci_hcd"
      "virtio_pci"
      "virtio_scsi"
    ];
    kernelModules = ["kvm-intel"];
    loader.grub = {
      enable = true;
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
  };

  environment = {
    etc."machine-id".text = "f7af645681b1dc8b1ac274fe0f22b26e";
    systemPackages = builtins.attrValues {
      inherit
        (pkgs)
        vim
        ;
    };
  };

  hardware.enableRedistributableFirmware = true;

  sops = {
    defaultSopsFile = ./secrets.yaml;
    age.sshKeyPaths = ["/var/lib/ssh/ssh_host_ed25519_key"];
    secrets.rfc2136_secret = {};
  };
}
