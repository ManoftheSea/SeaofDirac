{pkgs, ...}: {
  imports = [
    ./disko.nix
    ./network.nix
    ./services
  ];

  boot = {
    initrd.availableKernelModules = [
      "ahci"
      "sd_mod"
      "sr_mod"
      "virtio_pci"
      "virtio_scsi"
      "xhci_pci"
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
    etc."machine-id".text = "0edd0a4fb4982ed5397329bb65147cc2";
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
