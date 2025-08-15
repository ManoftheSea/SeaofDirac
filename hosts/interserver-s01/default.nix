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
    etc."machine-id".text = "1f92408841d8c2cdd5b4d88362bb8111";
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
  };
}
